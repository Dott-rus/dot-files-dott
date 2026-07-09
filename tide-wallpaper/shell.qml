import QtQuick
import Quickshell
import Quickshell.Io

Scope {
    id: shellRoot

    property string wallpaperPath: ""
    property point cursorPos: Qt.point(0, 0)

    function onWallpaperFileChanged() {
        for (var i = 0; i < wallpaperLayers.instances.length; i++) {
            var wl = wallpaperLayers.instances[i];
            if (wl) wl.reloadWallpaper(wallpaperPath);
        }
    }

    function onCursorUpdated(gx, gy) {
        cursorPos = Qt.point(gx, gy);
        for (var i = 0; i < wallpaperLayers.instances.length; i++) {
            var wl = wallpaperLayers.instances[i];
            if (wl) wl.applyParallax(gx, gy);
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
        onExited: running = false
    }

    Process {
        id: wallpaperWatcher
        running: false
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: function(data) {
                var line = String(data).trim();
                if (line !== "") shellRoot.onWallpaperFileChanged();
            }
        }
    }

    onWallpaperPathChanged: {
        if (wallpaperPath === "") return;
        wallpaperWatcher.command = [
            "inotifywait", "-m", "-e", "close_write", "--format", "%e",
            wallpaperPath
        ];
        wallpaperWatcher.running = true;
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
        configReader.running = true;
    }

    Component.onDestruction: {
        wallpaperWatcher.running = false;
        cursorReader.running = false;
    }

    Variants {
        id: wallpaperLayers
        model: Quickshell.screens

        WallpaperLayer {
            required property var modelData
            wallpaperPath: shellRoot.wallpaperPath
        }
    }
}
