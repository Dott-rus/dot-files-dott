import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    property string wallpaperPath: ""
    property real maxOffset: 8
    property real cursorX: 0
    property real cursorY: 0

    anchors { top: true; bottom: true; left: true; right: true }
    WlrLayershell.layer: WlrLayer.Overlay
    color: "transparent"

    function applyParallax(gx, gy) {
        cursorX = gx;
        cursorY = gy;
    }

    function reloadWallpaper(path) {
        if (!path || path === "") return;
        fadeOverlay.opacity = 1;
        reloadTimer.path = path;
        reloadTimer.restart();
    }

    Timer {
        id: reloadTimer
        property string path: ""
        interval: 4000
        onTriggered: {
            wallpaperImage.source = "";
            wallpaperImage.source = "file://" + encodeURI(path);
            fadeOverlay.opacity = 0;
        }
    }

    Rectangle {
        id: fadeOverlay
        anchors.fill: parent
        color: "#000000"
        opacity: 0
        Behavior on opacity {
            NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
        }
    }

    Image {
        id: wallpaperImage
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: false
        source: ""

        readonly property real normX: {
            var w = root.width;
            if (w <= 0) return 0.5;
            var relX = root.cursorX;
            return Math.max(0, Math.min(1, relX / w));
        }
        readonly property real normY: {
            var h = root.height;
            if (h <= 0) return 0.5;
            var relY = root.cursorY;
            return Math.max(0, Math.min(1, relY / h));
        }

        scale: 1.05
        x: (normX - 0.5) * -2 * root.maxOffset
        y: (normY - 0.5) * -2 * root.maxOffset

        Behavior on x { NumberAnimation { duration: 400; easing.type: Easing.OutQuint } }
        Behavior on y { NumberAnimation { duration: 400; easing.type: Easing.OutQuint } }
    }

    onWallpaperPathChanged: {
        if (wallpaperPath !== "")
            wallpaperImage.source = "file://" + encodeURI(wallpaperPath);
    }
}
