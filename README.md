# IPadMode

A native Caelestia quick toggle for a Hyprland headless output streamed to an
iPad with Weylus over Tailscale.

Off is one round power button. While active, the same slot separates into two
clear actions: power on the left and Extend/Duplicate on the right. State is
read back from Hyprland instead of being guessed by the UI.

The power action is deliberately soft: it stops or starts Weylus while leaving
the headless output in place, so Hyprland never shuffles workspaces just because
streaming was toggled. Use `ipad-mode remove` when a true output teardown is
wanted; that command safely returns the iPad workspaces to the laptop.

## Requires

- Hyprland with headless-output support
- Weylus Community Edition
- Tailscale
- `ipad-mode` and `ipad-weylus.service` from the private/system integration
  repository for the host
- A Caelestia shell carrying the plugin loader

The plugin contains no access code, tailnet hostname, IP address, or other host
identity. Weylus keeps its access code in its own private Flatpak configuration.

## Settings

The Caelestia Plugins page exposes the default display mode, resolution,
refresh rate, scale, placement, Sumi auto-launch, and disconnect behavior.

## Install

Clone into Caelestia's plugin directory:

    git clone https://github.com/dcqwqc/caelestia-plugin-ipad-mode ~/.local/share/caelestia/plugins/ipad-mode

Then enable `dcqwqc/ipadmode` in Nexus → Plugins and add `ipadMode` to the
utilities quick-toggle list.

## Licence

GPL-3.0-or-later, matching Caelestia.
