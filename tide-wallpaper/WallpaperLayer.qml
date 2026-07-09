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

    Rectangle {
        id: debugBg
        anchors.fill: parent
        color: "#ff6600"
        opacity: 0.5
        z: 1
    }

    Item {
        id: parallaxLayer
        anchors.fill: parent
        z: 2

        Rectangle {
            id: debugPill
            width: 200
            height: 100
            anchors.centerIn: parent
            color: "#000000"
            opacity: 0.8
            radius: 12

            Text {
                anchors.centerIn: parent
                color: "white"
                font.pixelSize: 20
                font.family: "monospace"
                text: "tide-wallpaper"
            }
        }

        readonly property real normX: {
            const w = root.width;
            if (w <= 0) return 0.5;
            const relX = root.cursorX - (root.screen ? root.screen.geometry.x : 0);
            return Math.max(0, Math.min(1, relX / w));
        }
        readonly property real normY: {
            const h = root.height;
            if (h <= 0) return 0.5;
            const relY = root.cursorY - (root.screen ? root.screen.geometry.y : 0);
            return Math.max(0, Math.min(1, relY / h));
        }

        x: (normX - 0.5) * -2 * root.maxOffset
        y: (normY - 0.5) * -2 * root.maxOffset

        Behavior on x { NumberAnimation { duration: 400; easing.type: Easing.OutQuint } }
        Behavior on y { NumberAnimation { duration: 400; easing.type: Easing.OutQuint } }
    }
}
