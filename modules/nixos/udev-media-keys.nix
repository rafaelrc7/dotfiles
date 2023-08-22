{ ... }:  {
  services.udev.extraHwdb = ''
    evdev:atkbd:dmi:bvn*:bvr*:bd*:br*:svn*:pn*:pvr*
    evdev:atkbd:dmi:bvn*:bvr*:bd*:br*:svn*:pn*:pvr*
     KEYBOARD_KEY_a0=!mute
     KEYBOARD_KEY_ae=!volumedown
     KEYBOARD_KEY_b0=!volumeup
  '';
}

