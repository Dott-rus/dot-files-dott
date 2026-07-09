import QtQuick
import Quickshell
import Quickshell.Wayland

Scope {
    PanelWindow {
        anchors { top: true; bottom: true; left: true; right: true }
        WlrLayershell.layer: WlrLayer.Overlay
        color: "#ff0000"
    }
}
