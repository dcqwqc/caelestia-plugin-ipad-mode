pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Caelestia

Singleton {
    id: root

    readonly property string bin: `${Quickshell.env("HOME")}/.local/bin/ipad-mode`

    property bool available: false
    property bool active: false
    property string mode: "off"
    property string preferredMode: "extend"
    property bool weylusRunning: false
    property bool tailscaleConnected: false
    property string pendingAction: ""
    readonly property bool busy: action.running || statusProc.running

    function refresh(): void {
        if (!statusProc.running && !action.running)
            statusProc.running = true;
    }

    function runAction(args: list<string>, label: string): void {
        if (root.busy)
            return;
        root.pendingAction = label;
        action.command = [root.bin, "--quiet"].concat(args);
        action.running = true;
    }

    function togglePower(): void {
        runAction(["toggle"], active ? "off" : "on");
    }

    function toggleMode(): void {
        runAction(["mode", mode === "duplicate" ? "extend" : "duplicate"], "mode");
    }

    Process {
        id: statusProc

        command: [root.bin, "status", "--json"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const value = JSON.parse(text);
                    root.available = !!value.available;
                    root.active = !!value.active;
                    root.mode = value.mode || "off";
                    root.preferredMode = value.preferredMode || "extend";
                    root.weylusRunning = !!value.weylusRunning;
                    root.tailscaleConnected = !!value.tailscaleConnected;
                } catch (e) {
                    root.available = false;
                }
            }
        }
    }

    Process {
        id: action

        running: false
        stderr: StdioCollector {
            id: actionError
        }
        onExited: code => {
            const label = root.pendingAction;
            root.pendingAction = "";
            if (code !== 0) {
                const detail = actionError.text.trim().replace(/^ipad-mode:\s*/, "");
                Toaster.toast(qsTr("iPad Mode failed"), detail || qsTr("The display could not be changed"), "error");
            } else if (label === "on") {
                Toaster.toast(qsTr("iPad Mode on"), qsTr("Weylus is ready on the virtual display"));
            } else if (label === "off") {
                Toaster.toast(qsTr("iPad Mode off"), qsTr("Display layout kept in place"));
            }
            root.refresh();
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }
}
