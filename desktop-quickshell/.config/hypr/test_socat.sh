#!/bin/bash
socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock > socat_out.log &
SOCAT_PID=$!
sleep 1
hyprctl dispatch workspace 2
sleep 0.5
hyprctl dispatch workspace 1
sleep 0.5
kill $SOCAT_PID
