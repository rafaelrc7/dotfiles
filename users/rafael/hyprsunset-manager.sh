set -euo pipefail

[[ -z $XDG_RUNTIME_DIR ]] && exit 1
[[ -z $HYPRLAND_INSTANCE_SIGNATURE ]] && exit 1

HYPRLAND_EVENT_SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
HYPRLAND_REQUEST_SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket.sock"

[[ ! -S $HYPRLAND_EVENT_SOCKET ]] && exit 1
[[ ! -S $HYPRLAND_REQUEST_SOCKET ]] && exit 1

ENABLED=no

HYPRSUNSET_IGNORE_CLASS="${HYPRSUNSET_IGNORE_CLASS:-a^}"
HYPRSUNSET_IGNORE_TITLE="${HYPRSUNSET_IGNORE_TITLE:-a^}"
HYPRSUNSET_NIGHT_TEMP="${HYPRSUNSET_NIGHT_TEMP:-4000}"
HYPRSUNSET_NIGHT_TIME="${HYPRSUNSET_NIGHT_TIME:-17:30}"
HYPRSUNSET_DAY_TIME="${HYPRSUNSET_DAY_TIME:-5:30}"

FIFO="$XDG_RUNTIME_DIR/hyprsunset-manager"

[[ -e $FIFO ]] && rm "$FIFO"
mkfifo "$FIFO"
trap cleanup EXIT

cleanup() {
	echo "Cleanup"
	read -ra JOBS <<<"$(jobs -p | tr '\n' ' ')"
	if [[ ${#JOBS[@]} -ne 0 ]]; then
		kill -s SIGKILL "${JOBS[@]}" || :
	fi
	[[ -p "$FIFO" ]] && rm "$FIFO"
	exit
}

is_day_time() {
	CURRENT_TIME="$(date +'%T')"
	if dtest "$CURRENT_TIME" --ge "$HYPRSUNSET_DAY_TIME" && dtest "$CURRENT_TIME" --lt "$HYPRSUNSET_NIGHT_TIME"; then
		true
	else
		false
	fi
}

poll_time() {
	if is_day_time; then
		day_time
	else
		night_time
	fi
}

day_time() {
	echo "disable" > "$FIFO"
	sleep_until "$HYPRSUNSET_NIGHT_TIME"
	poll_time
}

night_time() {
	echo "enable" > "$FIFO"
	sleep_until "$HYPRSUNSET_DAY_TIME"
	poll_time
}

sleep_until() {
	CURRENT_TIME="$(date +'%s')"
	TARGET_TIME=$(date -d "$1" +'%s')

	if [[ $TARGET_TIME -le $CURRENT_TIME ]]; then
		TARGET_TIME=$(date -d "tomorrow $1" +'%s')
	fi
	SLEEP_SECONDS=$((TARGET_TIME - CURRENT_TIME))

	sleep $SLEEP_SECONDS
}

handle_hyprland_event() {
  case "$1" in
	  activewindow\>\>*) check_window ;;
	  fullscreen\>\>*) check_window ;;
  esac
}

check_window() {
	hyprctl -j activewindow \
		| jq -e 'select(.fullscreen > 1 or (.class|test("$HYPRSUNSET_IGNORE_CLASS")) or (.title|test("$HYPRSUNSET_IGNORE_TITLE")))' > /dev/null \
		&& echo "disable" > "$FIFO" \
		|| echo "enable" > "$FIFO"
}

# Listen to Hyprland IPC
socat -U - "UNIX-CONNECT:$HYPRLAND_EVENT_SOCKET" \
	| while read -r line; do handle_hyprland_event "$line"; done &

# Poll time
poll_time &

enable_hyprsunset() {
	if is_day_time; then
		set_hyprsunset no
	else
		set_hyprsunset yes
	fi
}

disable_hyprsunset() {
	set_hyprsunset no
}

set_hyprsunset() {
	if [[ "$1" != "$ENABLED" ]]; then
		case $1 in
			yes)
				ENABLED=yes
				hyprctl hyprsunset temperature "$HYPRSUNSET_NIGHT_TEMP" >/dev/null
				;;
			no)
				ENABLED=no
				hyprctl hyprsunset identity >/dev/null
				;;
			*) echo "Unknown call 'set_hyprsunset $1'" ;;
		esac
	fi
}

while read -r msg < "$FIFO"; do
	case "$msg" in
		enable) enable_hyprsunset;;
		disable) disable_hyprsunset;;
	esac
done

