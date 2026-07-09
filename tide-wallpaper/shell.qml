import QtQuick
import Quickshell
import Quickshell.Io

Scope {
    id: shellRoot

    property string wallpaperPath: ""
    property point cursorPos: Qt.point(0, 0)

    function onWallpaperFileChanged() {
        for (var i = 0; i < wallpaperLayerRepeater.count; i++) {
            var item = wallpaperLayerRepeater.itemAt(i);
            if (item) item.reloadWallpaper(wallpaperPath);
        }
    }

    function onCursorUpdated(gx, gy) {
        cursorPos = Qt.point(gx, gy);
        for (var i = 0; i < wallpaperLayerRepeater.count; i++) {
            var item = wallpaperLayerRepeater.itemAt(i);
            if (item) item.applyParallax(gx, gy);
        }
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
                if (p !== "") shellRoot.wallpaperPath = p;
            }
        }
    }

    property int lastWallpaperMtime: 0

    function checkWallpaperMtime() {
        if (wallpaperPath === "") return;
        var cmd = ["stat", "-c", "%Y", wallpaperPath];
        var proc = checkMtimeProcess;
        proc.command = cmd;
        proc.running = true;
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
                        shellRoot.onCursorUpdated(pos.x, pos.y);
                } catch (e) {}
            }
        }
    }

    Component.onCompleted: {
        console.log("tide-wallpaper starting, screens:", Quickshell.screens.length);
        configReader.running = true;
    }

    Component.onDestruction: {
        cursorReader.running = false;
    }

    Repeater {
        id: wallpaperLayerRepeater
        model: Quickshell.screens

        delegate: WallpaperLayer {
            screen: modelData
            wallpaperPath: shellRoot.wallpaperPath
        }
    }
}
