{ pkgs, ... }: {
  services.mpd = {
    enable = true;
    extraConfig = ''
      audio_output {
          type                    "fifo"
          name                    "Visualizer feed"
          path                    "/tmp/mpd.fifo"
          format                  "44100:16:2"
          buffer_time             "10000"
      }

      audio_output {
        type            "pipewire"
        name            "PipeWire Sound Server"
      }
    '';
  };

  services.mpdris2.enable = true;

  programs.ncmpcpp = {
    enable = true;
    package = pkgs.ncmpcpp.override { visualizerSupport = true; };
    settings = {
      visualizer_data_source = "/tmp/mpd.fifo";
      visualizer_output_name = "Visualizer feed";
      visualizer_fps = 60;
      visualizer_in_stereo = "yes";
      visualizer_type = "spectrum";
      visualizer_look = "●▮";
      visualizer_color = "47, 83, 119, 155, 191, 227, 221, 215, 209, 203, 197, 161";
      visualizer_spectrum_smooth_look = "yes";
    };
  };

  home.file."Music/.mpdignore".text = ''
    soundboard
  '';

  home.packages = with pkgs; [
    mpc-cli
  ];
}

