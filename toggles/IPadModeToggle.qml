import QtQuick
import Caelestia.Config
import qs.components
import qs.services
import dcqwqc.ipadmode.services as IPad

// One native-sized quick-toggle surface. When iPad Mode is active the surface
// gains two clipped hit zones: power on the left and display mode on the right.
StyledRect {
    id: root

    property bool fillWidth: true
    property bool shapeMorph: true
    property real shapeMorphExpansion: shapeMorph && (powerLayer.pressed || modeLayer.pressed) ? 24 : 0

    implicitWidth: implicitHeight
    implicitHeight: powerIcon.implicitHeight + Tokens.padding.small * 2
    visible: IPad.IPadMode.available
    enabled: !IPad.IPadMode.busy
    opacity: enabled ? 1 : 0.62
    clip: true

    readonly property bool split: IPad.IPadMode.active
    readonly property real powerWidth: split ? Math.round(width * 0.48) : width
    readonly property color activeColour: Colours.palette.m3secondary
    readonly property color activeOnColour: Colours.palette.m3onSecondary
    readonly property color inactiveColour: Colours.layer(Colours.palette.m3surfaceContainerHighest, 2)
    readonly property color inactiveOnColour: Colours.palette.m3onSurfaceVariant

    radius: split || powerLayer.pressed || modeLayer.pressed
        ? Tokens.rounding.medium
        : Math.min(width, height) / 2 * Math.min(1, Tokens.rounding.scale)
    color: split ? activeColour : inactiveColour

    Item {
        id: powerAction

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: root.powerWidth

        StateLayer {
            id: powerLayer

            color: root.split ? root.activeOnColour : root.inactiveOnColour
            disabled: !root.enabled
            onClicked: IPad.IPadMode.togglePower()
        }

        MaterialIcon {
            id: powerIcon

            anchors.centerIn: parent
            anchors.verticalCenterOffset: 1
            text: IPad.IPadMode.busy ? "progress_activity"
                : root.split ? "power_settings_new" : "tablet_mac"
            color: root.split ? root.activeOnColour : root.inactiveOnColour
            fill: root.split ? 1 : 0
            fontStyle: Tokens.font.icon.medium

            RotationAnimator on rotation {
                running: IPad.IPadMode.busy
                from: 0
                to: 360
                duration: 900
                loops: Animation.Infinite
            }
        }
    }

    Item {
        id: modeAction

        visible: root.split
        opacity: root.split ? 1 : 0
        anchors.left: powerAction.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        // The barely-there tint separates the action without turning it into
        // a second floating pill.
        Rectangle {
            anchors.fill: parent
            color: root.activeOnColour
            opacity: 0.065
        }

        StateLayer {
            id: modeLayer

            color: root.activeOnColour
            disabled: !root.enabled
            onClicked: IPad.IPadMode.toggleMode()
        }

        MaterialIcon {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 1
            text: IPad.IPadMode.mode === "duplicate" ? "content_copy" : "view_week"
            color: root.activeOnColour
            fill: 1
            fontStyle: Tokens.font.icon.medium
        }

        Behavior on opacity { Anim { type: Anim.DefaultEffects } }
    }

    Rectangle {
        visible: root.split
        anchors.left: powerAction.right
        anchors.verticalCenter: parent.verticalCenter
        width: 1
        height: Math.round(parent.height * 0.48)
        color: root.activeOnColour
        opacity: 0.28
    }

    Behavior on radius { Anim { type: Anim.FastSpatial } }
    Behavior on opacity { Anim { type: Anim.DefaultEffects } }

    onVisibleChanged: if (visible)
        IPad.IPadMode.refresh()
}
