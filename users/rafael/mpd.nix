{ pkgs, ... }: {
  services.mpd = {
    enable = true;
    extraConfig = ''
      audio_output {
          type                    "fifo"
          name                    "my_fifo"
          path                    "/tmp/mpd.fifo"
          format                  "44100:16:2"
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
      visualizer_sync_interval = "1";
      visualizer_data_source = "/tmp/mpd.fifo";
      visualizer_output_name = "my_fifo";
      visualizer_in_stereo = "yes";
      visualizer_type = "spectrum";
      visualizer_look = "+|";
    };
  };

  home.file."Music/.mpdignore".text = ''
    soundboard
  '';

  home.packages = with pkgs; [
    mpc-cli
  ];
}

