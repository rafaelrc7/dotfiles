{ ... }:
{
  systemd.oomd = {
    enable = true;
    enableUserSlices = true;
    enableSystemSlice = true;
    enableRootSlice = true;
    extraConfig = {
      DefaultMemoryPressureDurationSec = "20";
      SwapUsedLimit = "90%";
    };
  };

  systemd.settings.Manager = {
    DefaultCPUAccounting = true;
    DefaultIOAccounting = true;
    DefaultMemoryAccounting = true;
    DefaultTasksAccounting = true;
  };

  # Services
  systemd.services."user@".serviceConfig = {
    ManagedOOMMemoryPressure = "kill";
    ManagedOOMMemoryPressureLimit = "40%";
  };

  # Slices
  ## Root
  systemd.slices."-".sliceConfig = {
    ManagedOOMSwap = "kill";
    ManagedOOMMemoryPressure = "kill";
    ManagedOOMMemoryPressureLimit = "80%";
  };

  ## System
  systemd.slices."system".sliceConfig = {
    ManagedOOMSwap = "kill";
    ManagedOOMMemoryPressure = "kill";
    ManagedOOMMemoryPressureLimit = "80%";
  };

  ## User
  systemd.slices.user.sliceConfig = {
    ManagedOOMSwap = "kill";
    ManagedOOMMemoryPressure = "kill";
    ManagedOOMMemoryPressureLimit = "40%";
  };

  systemd.slices."user-".sliceConfig = {
    ManagedOOMSwap = "kill";
    ManagedOOMMemoryPressure = "kill";
    ManagedOOMMemoryPressureLimit = "40%";
  };
}
