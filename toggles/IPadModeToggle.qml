import QtQuick
import Caelestia.Config
import qs.components
import qs.services
import dcqwqc.ipadmode.services as IPad

// One slot while off; two clean actions while on. The left half always owns
// power, while the right half alternates Extend and Duplicate without changing
// what the power action means underneath the user.
Item {
    id: root

    property bool fillWidth: true
    property bool shapeMorph: true
    property real shapeMorphExpansion: 0

    implicitWidth: implicitHeight
    implicitHeight: powerIcon.implicitHeight + Tokens.padding.small * 2
    visible: IPad.IPadMode.available
    enabled: !IPad.IPadMode.busy
    opacity: enabled ? 1 : 0.55

    property real gap: IPad.IPadMode.active ? Math.floor(Tokens.spacing.extraSmall) : 0
    readonly property real halfWidth: (width - gap) / 2
    readonly property color activeColour: Colours.palette.m3secondary
    readonly property color activeOnColour: Colours.palette.m3primary
    readonly property color inactiveColour: Colours.layer(Colours.palette.m3surfaceContainerHighest, 2)
    readonly property color inactiveOnColour: Colours.palette.m3onSurfaceVariant

    StyledRect {
        id: power

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: IPad.IPadMode.active ? root.halfWidth : root.width
        radius: IPad.IPadMode.active ? Tokens.rounding.medium : height / 2 * Math.min(1, Tokens.rounding.scale)
        topLeftRadius: height / 2 * Math.min(1, Tokens.rounding.scale)
        bottomLeftRadius: topLeftRadius
        color: IPad.IPadMode.active ? root.activeColour : root.inactiveColour

        StateLayer {
            color: IPad.IPadMode.active ? root.activeOnColour : root.inactiveOnColour
            disabled: !root.enabled
            rect.topLeftRadius: power.topLeftRadius
            rect.bottomLeftRadius: power.bottomLeftRadius
            onClicked: IPad.IPadMode.togglePower()
        }

        MaterialIcon {
            id: powerIcon

            anchors.centerIn: parent
            text: IPad.IPadMode.active ? "tablet_mac" : "tablet"
            color: IPad.IPadMode.active ? root.activeOnColour : root.inactiveOnColour
            fill: IPad.IPadMode.active ? 1 : 0
            fontStyle: Tokens.font.icon.medium
        }
    }

    StyledRect {
        id: displayMode

        visible: IPad.IPadMode.active
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: root.halfWidth
        radius: Tokens.rounding.medium
        topRightRadius: height / 2 * Math.min(1, Tokens.rounding.scale)
        bottomRightRadius: topRightRadius
        color: root.activeColour

        StateLayer {
            color: root.activeOnColour
            disabled: !root.enabled
            rect.topRightRadius: displayMode.topRightRadius
            rect.bottomRightRadius: displayMode.bottomRightRadius
            onClicked: IPad.IPadMode.toggleMode()
        }

        MaterialIcon {
            anchors.centerIn: parent
            text: IPad.IPadMode.mode === "duplicate" ? "content_copy" : "view_week"
            color: root.activeOnColour
            fill: 1
            fontStyle: Tokens.font.icon.medium
        }
    }

    Behavior on gap { Anim { type: Anim.FastSpatial } }
    Behavior on opacity { Anim { type: Anim.DefaultEffects } }

    onVisibleChanged: if (visible)
        IPad.IPadMode.refresh()
}
