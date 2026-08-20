-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function () 
  hl.exec_cmd("waybar")
  hl.exec_cmd("swaync-client")
  hl.exec_cmd("awww-daemon")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
  hl.exec_cmd("~/.config/hypr/scripts/brightness.sh")
  hl.exec_cmd("~/.config/hypr/scripts/volume.sh")
end)

