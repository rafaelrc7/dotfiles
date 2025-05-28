set -euo pipefail

[[ -z $XDG_RUNTIME_DIR ]] && exit 1
[[ -z $HYPRLAND_INSTANCE_SIGNATURE ]] && exit 1

HYPRLAND_EVENT_SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
[[ ! -S $HYPRLAND_EVENT_SOCKET ]] && exit 1

FIFO="$XDG_RUNTIME_DIR/hyprsunset-manager"

check_window() {
	if hyprctl -j activewindow \
		| jq -e 'select(.fullscreen > 1 or (.class|test("$HYPRSUNSET_IGNORE_CLASS")) or (.title|test("$HYPRSUNSET_IGNORE_TITLE")))' \
			> /dev/null
	then
		[[ -p "$FIFO" ]] && echo "pause" > "$FIFO"
	else
		[[ -p "$FIFO" ]] && echo "unpause" > "$FIFO"
	fi
}

handle_hyprland_event() {
  case "$1" in
	  activewindow\>\>*|fullscreen\>\>*) check_window ;;
	  *) ;;
  esac
}

socat -U - "UNIX-CONNECT:$HYPRLAND_EVENT_SOCKET" \
	| while read -r line; do handle_hyprland_event "$line"; done

