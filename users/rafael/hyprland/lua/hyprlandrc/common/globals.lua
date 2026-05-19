local M = {}

M.exec_prefix = "uwsm app -- "

M.programs = {}
M.programs.launcher_menu = 'fuzzel --hide-before-typing --launch-prefix="' .. M.exec_prefix .. '"'
M.programs.terminal = "kitty"
M.programs.browser = "firefox"
M.programs.file_manager = "dolphin"
M.programs.printscreen = "flameshot gui"
M.programs.calculator = "qalculate-qt"

return M
