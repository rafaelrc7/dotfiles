local programs = require("hyprlandrc.common.globals").programs
local exec_cmd = require("hyprlandrc.common.utils").exec_cmd

hl.workspace_rule { workspace = "10", monitor = "desc:LG Electronics LG FULL HD 0x01010101", default = true }
hl.workspace_rule { workspace = "special:scratchpad", on_created_empty = exec_cmd(programs.terminal) }
hl.workspace_rule { workspace = "special:calculator", on_created_empty = exec_cmd(programs.calculator) }
hl.workspace_rule { workspace = "special:screen-record", on_created_empty = exec_cmd "gpu-screen-recorder-gtk" }
