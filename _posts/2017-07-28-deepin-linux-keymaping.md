---
layout: post
title:  "Deepin Linux Key Mapping"
date:   2018-05-10 23:04:37 +1200
categories: posts
---

1. To change mapping of Caps Lock, do this fist:

[code]gsettings set com.deepin.dde.keybinding.mediakey capslock '[]'[/code]

2. Then, you can re-map capslock with prefered layout-options.

Swap Caps Lock and Esc:

[code]gsettings set com.deepin.dde.keyboard layout-options '["caps:swapescape"]'[/code]

Map Caps Lock to Esc:

[code]gsettings set com.deepin.dde.keyboard layout-options '["caps:escape"]'[/code]

Disable Caps Lock:

[code]gsettings set com.deepin.dde.keyboard layout-options '["caps:none"]'[/code]

It works immediately on my Thinkpad X1 Carbon, without logout or restart.

3. Get all layout-options:

[code]localectl list-x11-keymap-options[/code]

4. Get all layout-options for capslock only:

[code]localectl list-x11-keymap-options | grep caps:[/code]

List:

[code]
caps:backspace
caps:capslock
caps:ctrl_modifier
caps:escape
caps:hyper
caps:internal
caps:internal_nocancel
caps:menu
caps:none
caps:numlock
caps:shift
caps:shift_nocancel
caps:shiftlock
caps:super
caps:swapescape
[/code]

5. If you mess up, reset related KEY to default:

[code]
gsettings reset com.deepin.dde.keybinding.mediakey capslock
gsettings reset com.deepin.dde.keyboard layout-options
[/code]

Or reset the SCHEMA:

[code]
gsettings reset-recursively com.deepin.dde.keybinding.mediakey
gsettings reset-recursively com.deepin.dde.keyboard
[/code]
