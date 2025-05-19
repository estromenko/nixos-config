{
  icon_theme = "Tela-circle-nord";
  position = "top";
  margin.bottom = -20;
  start = [
    {
      type = "launcher";
      favorites = ["rio" "google-chrome" "telegram" "amnezia" "onlyoffice-desktopeditors" "zed"];
      show_names = false;
      show_icons = true;
      reversed = false;
    }

    {
      type = "music";
      truncate.mode = "end";
      truncate.max_length = 40;
    }
  ];
  end = [
    {
      type = "tray";
      icon_size = 42;
    }

    {
      type = "volume";
      on_scroll_down = "wpctl set-volume @DEFAULT_SINK@ 3%-";
      on_scroll_up = "wpctl set-volume @DEFAULT_SINK@ 3%+ --limit 100";
    }

    {type = "upower";}

    {type = "notifications";}

    {
      type = "clock";
      format = "%H:%M %d.%m";
    }
    {
      type = "custom";
      class = "power-menu";

      bar = [
        {
          type = "button";
          name = "power-btn";
          label = "";
          on_click = "popup:toggle";
        }
      ];
      popup = [
        {
          type = "box";
          orientation = "vertical";
          widgets = [
            {
              type = "label";
              name = "header";
              label = "Power menu";
            }
            {
              type = "box";
              widgets = [
                {
                  type = "button";
                  class = "power-btn";
                  label = "<span font-size='20pt'></span>";
                  on_click = "!shutdown now";
                }
                {
                  type = "button";
                  class = "power-btn";
                  label = "<span font-size='20pt'></span>";
                  on_click = "!reboot";
                }
                {
                  type = "button";
                  class = "power-btn";
                  label = "<span font-size='20pt'>logout</span>";
                  on_click = "!systemctl suspend";
                }
              ];
            }
            {
              type = "label";
              name = "uptime";
              label = "Uptime: {{30000:uptime | cut -d ' ' -f2}}";
            }
          ];
        }
      ];

      tooltip = "Up: {{30000:uptime | cut -d ' ' -f2}}";
    }
  ];
}
