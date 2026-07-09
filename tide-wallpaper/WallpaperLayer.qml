import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root
    property string wallpaperPath: ""
    property real fadeDuration: 200
    property real maxOffset: 8

    property real cursorX: 0
    property real cursorY: 0

    color: "transparent"
    anchors { top: true; bottom: true; left: true; right: true }

    WlrLayershell.layer: WlrLayer.Bottom
    mask: Region {}

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
            wallpaperImage.source = "file://" + path;
            fadeOverlay.opacity = 0;
        }
    }

    Rectangle {
        id: fadeOverlay
        anchors.fill: parent
        color: "#000000"
        opacity: 0
        z: 2

        Behavior on opacity {
            NumberAnimation { duration: root.fadeDuration; easing.type: Easing.InOutQuad }
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
            const w = root.width;
            if (w <= 0) return 0.5;
            const relX = root.cursorX - root.screen.geometry.x;
            return Math.max(0, Math.min(1, relX / w));
        }
        readonly property real normY: {
            const h = root.height;
            if (h <= 0) return 0.5;
            const relY = root.cursorY - root.screen.geometry.y;
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
            wallpaperImage.source = "file://" + wallpaperPath;
    }
}
