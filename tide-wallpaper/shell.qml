import QtQuick
import Quickshell
import Quickshell.Io

Scope {
    id: shellRoot

    property string wallpaperPath: ""
    property int lastWallpaperMtime: 0

    WallpaperLayer {
        id: wallpaperLayer
        wallpaperPath: shellRoot.wallpaperPath
    }

    function onWallpaperFileChanged() {
        wallpaperLayer.reloadWallpaper(wallpaperPath);
    }

    function checkWallpaperMtime() {
        if (wallpaperPath === "") return;
        checkMtimeProcess.command = ["stat", "-c", "%Y", wallpaperPath];
        checkMtimeProcess.running = true;
    }

    Process {
        id: configReader
        command: [
            "sh", "-c",
            "sed 's|^[[:space:]]*//.*||' \"$HOME/.config/tide-island/userconfig.json\" | python3 -c \"import sys,json; print(json.load(sys.stdin)['wallpaperPath'])\""
        ]
        running: false
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: function(data) {
                var p = String(data).trim();
                if (p !== "") {
                    shellRoot.wallpaperPath = p;
                    shellRoot.lastWallpaperMtime = Date.now() / 1000;
                }
            }
        }
    }

    Process {
        id: checkMtimeProcess
        running: false
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: function(data) {
                var mtime = parseInt(String(data).trim());
                if (!isNaN(mtime) && mtime > shellRoot.lastWallpaperMtime) {
                    shellRoot.lastWallpaperMtime = mtime;
                    shellRoot.onWallpaperFileChanged();
                }
            }
        }
    }

    Timer {
        id: pollTimer
        interval: 2000
        running: wallpaperPath !== ""
        repeat: true
        onTriggered: checkWallpaperMtime()
    }

    onWallpaperPathChanged: {
        if (wallpaperPath === "") return;
        pollTimer.running = true;
        checkWallpaperMtime();
    }

    Timer {
        id: cursorTimer
        interval: 16
        running: true
        repeat: true
        onTriggered: {
            if (!cursorReader.running)
                cursorReader.running = true;
        }
    }

    Process {
        id: cursorReader
        command: ["hyprctl", "-j", "cursorpos"]
        running: false
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: function(data) {
                var raw = String(data).trim();
                if (raw === "" || raw.charAt(0) !== "{") return;
                try {
                    var pos = JSON.parse(raw);
                    if (pos && typeof pos.x === "number" && typeof pos.y === "number")
                        wallpaperLayer.applyParallax(pos.x, pos.y);
                } catch (e) {}
            }
        }
    }

    Component.onCompleted: {
        configReader.running = true;
    }
}
