# IPadMode

A native Caelestia quick toggle for a Hyprland headless output streamed to an
iPad with Weylus over Tailscale.

Off is one round power button. While active, the same slot separates into two
clear actions: power on the left and Extend/Duplicate on the right. State is
read back from Hyprland instead of being guessed by the UI.

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
