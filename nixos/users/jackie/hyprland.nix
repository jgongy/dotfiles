{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # QT_QPA_PLATFORMTHEME env variable
    qt6ct

    # Authentication agent
    # polkit-kde-agent
  ];

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.settings = {
    monitor = "DP-1,1920x1080@144,0x0,1";
    # monitor = ",preferred,auto,auto";

    # exec-once = [
    #   "${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1"
    # ];

    env = [
      "XCURSOR_SIZE,24"
      "QT_QPA_PLATFORMTHEME,qt6ct"
    ];

    input = {
      kb_layout = "us";
      kb_options = "caps:ctrl_modifier";

      follow_mouse = 2;
      float_switch_override_focus = 0;
      accel_profile = "flat";

      repeat_rate = 25;
      repeat_delay = 225;

      touchpad = {
        natural_scroll = "false";
      };

      sensitivity = 0;
    };

    general = {
      gaps_in = 4;
      gaps_out = 8;
      border_size = 1;
      "col.active_border" = "rgba(00ff99ee) rgba(33ccffee) 45deg";
      "col.inactive_border" = "rgba(595959aa)";

      layout = "dwindle";
      allow_tearing = "false";
      no_cursor_warps = "true";
    };

    decoration = {
      rounding = 0;

      blur= {
        enabled = "true";
        size = 3;
        passes = 1;

        vibrancy = 0.1696;
      };

      drop_shadow = "true";
      shadow_range = 4;
      shadow_render_power = 3;
      "col.shadow" = "rgba(1a1a1aee)";
    };

    animations = {
      enabled = "true";

      bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

      animation = [
        "windows, 1, 7, myBezier"
        "windowsOut, 1, 7, default, popin 80%"
        "border, 1, 10, default"
        "borderangle, 1, 8, default"
        "fade, 1, 7, default"
        "workspaces, 1, 6, default"
      ];
    };

    dwindle = {
      pseudotile = "true";
      preserve_split = "true";
      force_split = 2;
    };

    master = {
      allow_small_split = "true";
      new_is_master = "false";
    };

    gestures = {
      workspace_swipe = "false";
    };

    misc = {
      force_default_wallpaper = -1;
    };

    # windowrulev2 = [
    #   "nomaximizerequest, class:.*"
    #   "noborder, onworkspace:1"
    # ];

    "$mod" = "ALT";
    "$terminal" = "wezterm";
    "$menu" = "anyrun";
    "$fileManager" = "dolphin";

    bind = [
      "$mod, RETURN, exec, $terminal"
      "$mod SHIFT, W, killactive,"
      "$mod SHIFT, Escape, exit,"
      "$mod, E, exec, $filemanager"
      "$mod SHIFT, F, togglefloating,"
      "$mod, Space, exec, $menu"
      "$mod SHIFT, Q, layoutmsg, addmaster" # master
      "$mod SHIFT, E, layoutmsg, removemaster" # master
      "$mod SHIFT, P, pseudo," # dwindle
      "$mod SHIFT, Q, togglesplit," # dwindle

      "$mod, left, movefocus, l"
      "$mod, right, movefocus, r"
      "$mod, up, movefocus, u"
      "$mod, down, movefocus, d"

      "$mod, H, movefocus, l"
      "$mod, L, movefocus, r"
      "$mod, K, movefocus, u"
      "$mod, J, movefocus, d"

      "$mod SHIFT, H, movewindow, l"
      "$mod SHIFT, L, movewindow, r"
      "$mod SHIFT, K, movewindow, u"
      "$mod SHIFT, J, movewindow, d"

      "$mod SHIFT, 1, workspace, 1"
      "$mod SHIFT, 2, workspace, 2"
      "$mod SHIFT, 3, workspace, 3"
      "$mod SHIFT, 4, workspace, 4"
      "$mod SHIFT, 5, workspace, 5"
      "$mod SHIFT, 6, workspace, 6"
      "$mod SHIFT, 7, workspace, 7"
      "$mod SHIFT, 8, workspace, 8"
      "$mod SHIFT, 9, workspace, 9"
      "$mod SHIFT, 0, workspace, 10"

      "$mod, 1, movetoworkspace, 1"
      "$mod, 2, movetoworkspace, 2"
      "$mod, 3, movetoworkspace, 3"
      "$mod, 4, movetoworkspace, 4"
      "$mod, 5, movetoworkspace, 5"
      "$mod, 6, movetoworkspace, 6"
      "$mod, 7, movetoworkspace, 7"
      "$mod, 8, movetoworkspace, 8"
      "$mod, 9, movetoworkspace, 9"
      "$mod, 0, movetoworkspace, 10"

      "$mod, S, togglespecialworkspace, scratchpad"
      "$mod SHIFT, S, movetoworkspace, special:scratchpad"

      "CTRL SHIFT SUPER, right, movetoworkspace, +1"
      "CTRL SHIFT SUPER, left, movetoworkspace, -1"

      "CTRL SUPER, right, workspace, +1"
      "CTRL SUPER, left, workspace, -1"
    ];

    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
    ];

    bindel = [
      ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_SINK@ 5%-"
    ];

    bindl = [
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_SINK@ toggle"
    ];

    workspace = "special:scratchpad, gapsout:16, gapsin:4, on-created-empty:wezterm";

  };

  wayland.windowManager.hyprland.extraConfig = ''
    bind = $mod, Tab, submap, changeWorkspace
    submap = changeWorkspace
    bind = $mod, L, workspace, +1
    bind = $mod, H, workspace, -1
    bind = $mod, L, submap, reset
    bind = $mod, H, submap, reset
    bind = , escape, submap, reset
    bind = , catchall, submap, reset
    submap = reset

    bind = $mod SHIFT, Tab, submap, moveWorkspace
    submap = moveWorkspace
    bind = $mod SHIFT, L, movetoworkspace, +1
    bind = $mod SHIFT, H, movetoworkspace, -1
    bind = $mod SHIFT, L, submap, reset
    bind = $mod SHIFT, H, submap, reset
    bind = , escape, submap, reset
    bind = , catchall, submap, reset
    submap = reset

    bind = $mod SHIFT, R, submap, resize
    submap = resize
    binde = $mod SHIFT, L, resizeactive, 10 0
    binde = $mod SHIFT, H, resizeactive, -10 0
    binde = $mod SHIFT, K, resizeactive, 0 -10
    binde = $mod SHIFT, J, resizeactive, 0 10
    bind = $mod, H, movefocus, l
    bind = $mod, L, movefocus, r
    bind = $mod, K, movefocus, u
    bind = $mod, J, movefocus, d
    bind = $mod SHIFT, F, centerwindow
    bind = $mod SHIFT, F, resizeactive, exact 90% 90%
    bind = , escape, submap, reset
    bind = $mod SHIFT, R, submap, reset
    submap = reset
  '';
}
