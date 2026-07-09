import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    property string wallpaperPath: ""
    property real maxOffset: 8
    property real cursorX: -1
    property real cursorY: -1

    anchors { top: true; bottom: true; left: true; right: true }
    WlrLayershell.layer: WlrLayer.Overlay
    color: "transparent"

    function applyParallax(gx, gy) {
        cursorX = gx;
        cursorY = gy;
        debugText.text = "path: " + wallpaperPath + "\ncur: " + gx + ", " + gy;
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

    Image {
        id: wallpaperImage
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: false
        source: ""

        onStatusChanged: {
            if (status === Image.Error)
                debugText.text += "\nERROR: " + source;
            else if (status === Image.Ready)
                debugText.text += "\nREADY";
        }

        readonly property real normX: {
            if (root.width <= 0) return 0.5;
            return Math.max(0, Math.min(1, root.cursorX / root.width));
        }
        readonly property real normY: {
            if (root.height <= 0) return 0.5;
            return Math.max(0, Math.min(1, root.cursorY / root.height));
        }

        scale: 1.05
        x: (normX - 0.5) * -2 * root.maxOffset
        y: (normY - 0.5) * -2 * root.maxOffset

        Behavior on x { NumberAnimation { duration: 400; easing.type: Easing.OutQuint } }
        Behavior on y { NumberAnimation { duration: 400; easing.type: Easing.OutQuint } }
    }

    onWallpaperPathChanged: {
        if (wallpaperPath !== "") {
            debugText.text = "path: " + wallpaperPath + "\nloading...";
            wallpaperImage.source = "file://" + wallpaperPath;
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 10
        width: debugText.width + 20
        height: debugText.height + 20
        color: "#88000000"
        radius: 8
        z: 10

        Text {
            id: debugText
            anchors.centerIn: parent
            color: "#00ff00"
            font.pixelSize: 14
            font.family: "monospace"
            text: "waiting..."
        }
    }
}
