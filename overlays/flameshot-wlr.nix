inputs: final: prev: {
  flameshot = prev.flameshot.override { enableWlrSupport = true; };
}
