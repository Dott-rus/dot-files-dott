//@ pragma UseQApplication

import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Hyprland._Ipc
import Quickshell.Io
import IslandBackend

Scope {
    id: shellRoot

    readonly property bool screenRecordingActive: SystemServices.screenRecordingActive
    property bool focusEnabled: false
    property bool nightLightEnabled: false
    property bool shuttingDown: false
    property string mode: "normal"

    readonly property var userConfig: UserConfig

    function forEachWindow(callback) {
        const windows = panelVariants.instances ? panelVariants.instances : [];
        for (let index = 0; index < windows.length; index++) {
            const window = windows[index];
            if (window)
                callback(window);
        }
    }

    function showNotificationAll(appName, summary, body) {
        if (focusEnabled)
            return;

        shellRoot.forEachWindow((window) => {
            if (window && window.showNotification)
                window.showNotification(appName, summary, body);
        });
    }

    function anyOverviewOpen() {
        const windows = panelVariants.instances ? panelVariants.instances : [];
        for (let index = 0; index < windows.length; index++) {
            const window = windows[index];
            if (window && window.overviewPhase !== "closed")
                return true;
        }

        return false;
    }

    function prepareOverviewAll() {
        shellRoot.forEachWindow((window) => window.prepareOverview());
    }

    function cancelPreparedOverviewAll() {
        shellRoot.forEachWindow((window) => window.cancelPreparedOverview());
    }

    function openOverviewAll() {
        shellRoot.forEachWindow((window) => window.openOverview());
    }

    function closeOverviewAll() {
        shellRoot.forEachWindow((window) => window.closeOverview());
    }

    function toggleOverviewAll() {
        if (shellRoot.anyOverviewOpen())
            shellRoot.closeOverviewAll();
        else
            shellRoot.openOverviewAll();
    }

    function setMode(mode) {
        if (["normal", "focus", "gaming"].indexOf(mode) !== -1)
            shellRoot.mode = mode;
    }

    function toggleFocus() {
        shellRoot.mode = shellRoot.mode === "focus" ? "normal" : "focus";
    }

    function toggleGaming() {
        shellRoot.mode = shellRoot.mode === "gaming" ? "normal" : "gaming";
    }

    function forFocusedWindow(callback) {
        const windows = panelVariants.instances ? panelVariants.instances : [];
        for (let index = 0; index < windows.length; index++) {
            const window = windows[index];
            if (window && window.monitorFocused) {
                callback(window);
                return;
            }
        }
    }

    IpcHandler {
        target: "overview"

        function toggle() {
            shellRoot.toggleOverviewAll();
        }

        function open() {
            shellRoot.openOverviewAll();
        }

        function close() {
            shellRoot.closeOverviewAll();
        }

        function refreshWallpaperCache() {
            shellRoot.forEachWindow((window) => {
                if (window && window.prewarmWallpaperCache)
                    window.prewarmWallpaperCache();
            });
        }
    }

    IpcHandler {
        target: "tide"

        function showClock() {
            shellRoot.forFocusedWindow((window) => window.showClockWindow());
        }

        function showCustom() {
            shellRoot.forFocusedWindow((window) => window.showCustomInfoWindow());
        }

        function showLyrics() {
            shellRoot.forFocusedWindow((window) => window.showLyricsWindow());
        }

        function togglePlayer() {
            shellRoot.forFocusedWindow((window) => window.togglePlayerWindow());
        }

        function toggleControlCenter() {
            shellRoot.forFocusedWindow((window) => window.toggleControlCenterWindow());
        }

        function toggleWallpaperPicker() {
            shellRoot.forFocusedWindow((window) => window.toggleWallpaperPickerWindow());
        }

        function modeNormal() {
            shellRoot.setMode("normal");
        }

        function modeFocus() {
            shellRoot.setMode("focus");
        }

        function modeGaming() {
            shellRoot.setMode("gaming");
        }

        function toggleFocus() {
            shellRoot.toggleFocus();
        }

        function toggleGaming() {
            shellRoot.toggleGaming();
        }

        function timerStop() {
            shellRoot.forFocusedWindow((window) => window.timerStop());
        }

        function timerToggle() {
            shellRoot.forFocusedWindow((window) => window.timerToggle(0, 5));
        }

        function timerCustom() {
            timerReader.running = true;
        }
    }

    Process {
        id: timerReader
        command: ["cat", "/tmp/tide-timer-duration"]
        running: false
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: function(data) {
                var text = String(data).trim();
                if (text === "") return;
                var parts = text.split(":");
                if (parts.length === 2) {
                    var h = parseInt(parts[0]) || 0;
                    var m = parseInt(parts[1]) || 0;
                    if (h > 0 || m > 0)
                        shellRoot.forFocusedWindow((window) => window.timerStart(h, m));
                }
            }
        }
    }

    GlobalShortcut {
        appid: "quickshell"
        name: "dynamic-island-overview"

        onPressed: shellRoot.toggleOverviewAll()
    }

    Connections {
        target: SystemServices

        function onNotificationReceived(appName, summary, body) {
            shellRoot.showNotificationAll(appName, summary, body);
        }
    }

    property string __lastLayout: ""

    Connections {
        target: Hyprland

        function onRawEvent(event) {
            if (event.name === "activelayout") {
                var parts = event.data.split(",");
                if (parts.length >= 2) {
                    var layoutName = parts.slice(1).join(",").trim();
                    if (layoutName === shellRoot.__lastLayout) return;
                    shellRoot.__lastLayout = layoutName;
                    shellRoot.forFocusedWindow(function(window) {
                        if (window && window.showLayoutIndicator)
                            window.showLayoutIndicator(layoutName);
                    });
                }
            }
        }
    }

    Component.onDestruction: {
        shuttingDown = true;
    }

    Component.onCompleted: {
        SystemServices.ensureSetupComplete(Quickshell.shellDir);
        SystemServices.requestScreenRecordingSnapshot();
    }

    Variants {
        id: panelVariants

        model: Quickshell.screens

        DynamicIslandWindow {
            required property var modelData

            screen: modelData
            shellRootController: shellRoot
        }
    }
}
