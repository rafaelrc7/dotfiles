set -euo pipefail

[[ -z $XDG_RUNTIME_DIR ]] && exit 1
[[ -z $XDG_DATA_HOME ]] && exit 1
[[ -z $HYPRLAND_INSTANCE_SIGNATURE ]] && exit 1

HYPRLAND_EVENT_SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
HYPRLAND_REQUEST_SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket.sock"

[[ ! -S $HYPRLAND_EVENT_SOCKET ]] && exit 1
[[ ! -S $HYPRLAND_REQUEST_SOCKET ]] && exit 1

HYPRSUNSET_IGNORE_CLASS="${HYPRSUNSET_IGNORE_CLASS:-a^}"
HYPRSUNSET_IGNORE_TITLE="${HYPRSUNSET_IGNORE_TITLE:-a^}"
HYPRSUNSET_NIGHT_TEMP="${HYPRSUNSET_NIGHT_TEMP:-4000}"
HYPRSUNSET_NIGHT_TIME="${HYPRSUNSET_NIGHT_TIME:-17:30}"
HYPRSUNSET_DAY_TIME="${HYPRSUNSET_DAY_TIME:-5:30}"

STATUS_FILE="$XDG_DATA_HOME/hyprsunset-manager-status.json"

# Default Values
ENABLED="yes"
PAUSED="no"
TEMPERATURE=4000
GAMMA=100

read_status_file() {
	local enabled temperature temperature_no_suffix new_temperature gamma new_gamma

	enabled="$(jq -r .enabled "$STATUS_FILE")"
	case "$enabled" in
		yes|no) ENABLED="$enabled";;
		*) echo "Invalid 'enabled' status '$enabled'";;
	esac

	temperature=$(jq -r .temperature "$STATUS_FILE")
	temperature_no_suffix="${temperature%"K"}"
	new_temperature=$(bc<<<"$temperature_no_suffix" || echo "")
	if [[ -n $new_temperature ]]; then
		TEMPERATURE=$new_temperature
	else
		echo "Invalid 'temperature' status '$temperature'"
	fi

	gamma=$(jq -r .gamma "$STATUS_FILE")
	new_gamma=$(bc<<<"$gamma" || echo "")
	if [[ -n $new_gamma ]]; then
		GAMMA=$new_gamma
	else
		echo "Invalid 'gamma' status '$gamma'"
	fi
}

store_status_file() {
	jq --null-input \
		--arg enabled "$ENABLED" \
		--arg temperature "${TEMPERATURE}K" \
		--arg gamma "$GAMMA" \
		'{"enabled": $enabled, "temperature": $temperature, "gamma": $gamma}' \
		> "$STATUS_FILE"
}

enable_hyprsunset() {
	if [[ $ENABLED == "no" ]]; then
		if [[ $PAUSED == "no" ]]; then
			send_hyprsunset_status
		fi
		ENABLED="yes"
		store_status_file
	fi
}

disable_hyprsunset() {
	if [[ $ENABLED == "yes" ]]; then
		if [[ $PAUSED == "no" ]]; then
			send_hyprsunset_default
		fi
		ENABLED="no"
		store_status_file
	fi
}

pause_hyprsunset() {
	if [[ $PAUSED == "no" ]]; then
		if [[ $ENABLED == "yes" ]]; then
			send_hyprsunset_default
		fi
		PAUSED="yes"
	fi
}

unpause_hyprsunset() {
	if [[ $PAUSED == "yes" ]]; then
		if [[ $ENABLED == "yes" ]]; then
			send_hyprsunset_status
		fi
		PAUSED="no"
	fi
}

set_hyprsunset_temperature() {
	local new_temperature
	new_temperature=$(bc<<<"$1" || echo "")
	if [[ -z $new_temperature ]]; then
		echo "Invalid temperature $1"
		return 0
	fi

	if [[ "$TEMPERATURE" != "$new_temperature" ]]; then
		TEMPERATURE=$new_temperature
		if [[ $ENABLED == "yes" && $PAUSED == "no" ]]; then
			send_hyprsunset_temperature
		fi
		store_status_file
	fi
}

set_hyprsunset_gamma() {
	local new_gamma
	new_gamma=$(bc<<<"$1" || echo "")
	if [[ -z $new_gamma ]]; then
		echo "Invalid gamma $1"
		return 0
	fi

	if [[ "$GAMMA" != "$new_gamma" ]]; then
		GAMMA=$new_gamma
		if [[ $ENABLED == "yes" && $PAUSED == "no" ]]; then
			send_hyprsunset_gamma
		fi
		store_status_file
	fi
}

send_hyprsunset_temperature() {
	hyprctl hyprsunset temperature "$TEMPERATURE" >/dev/null
}

send_hyprsunset_gamma() {
	hyprctl hyprsunset gamma "$GAMMA" >/dev/null
}

send_hyprsunset_status() {
	send_hyprsunset_temperature
	send_hyprsunset_gamma
}

send_hyprsunset_default() {
	hyprctl hyprsunset identity >/dev/null
	hyprctl hyprsunset gamma 100 >/dev/null
}

force_update_hyprsunset() {
	if [[ $ENABLED == "yes" && $PAUSED == "no" ]]; then
		send_hyprsunset_status
	else
		send_hyprsunset_default
	fi
}

if [[ -r $STATUS_FILE ]]; then
	read_status_file
else
	store_status_file
fi

force_update_hyprsunset

while read -r msg; do
	case "$msg" in
		enable) enable_hyprsunset ;;
		disable) disable_hyprsunset ;;
		pause) pause_hyprsunset ;;
		unpause) unpause_hyprsunset ;;
		force\ update) force_update_hyprsunset ;;
		temperature\ *)
			msg_without_prefix=${msg#"temperature "}
			set_hyprsunset_temperature "${msg_without_prefix%"K"}"
		;;
		gamma\ *)
			msg_without_prefix=${msg#"gamma "}
			set_hyprsunset_gamma "$msg_without_prefix"
		;;
		*) echo "Invalid command '$msg'";;
	esac
done

