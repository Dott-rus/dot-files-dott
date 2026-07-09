import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    property string wallpaperPath: ""
    property real maxOffset: 8
    property real cursorX: 0.5
    property real cursorY: 0.5

    anchors { top: true; bottom: true; left: true; right: true }
    WlrLayershell.layer: WlrLayer.Overlay
    color: "transparent"

    Item {
        id: coordHelper
        anchors.fill: parent
        visible: false
    }

    function applyParallax(gx, gy) {
        var local = coordHelper.mapFromGlobal(gx, gy);
        cursorX = local.x;
        cursorY = local.y;
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
        Behavior on opacity {
            NumberAnimation { duration: 200; easing.type: Easing.InOutQuad }
        }
    }

    Item {
        anchors.fill: parent
        clip: true

        Image {
            id: wallpaperImage
            width: parent.width * 1.05
            height: parent.height * 1.05
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            cache: false
            source: ""

            readonly property real normX: {
                if (root.width <= 0) return 0.5;
                return Math.max(0, Math.min(1, root.cursorX / root.width));
            }
            readonly property real normY: {
                if (root.height <= 0) return 0.5;
                return Math.max(0, Math.min(1, root.cursorY / root.height));
            }

            x: (parent.width - width) / 2 + (normX - 0.5) * -2 * root.maxOffset
            y: (parent.height - height) / 2 + (normY - 0.5) * -2 * root.maxOffset

            Behavior on x { NumberAnimation { duration: 400; easing.type: Easing.OutQuint } }
            Behavior on y { NumberAnimation { duration: 400; easing.type: Easing.OutQuint } }
        }
    }

    onWallpaperPathChanged: {
        if (wallpaperPath !== "") {
            wallpaperImage.source = "file://" + wallpaperPath;
        }
    }

    Rectangle {
        visible: false
    }
}
