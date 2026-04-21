#!/bin/bash
hyprctl monitors -j | jq --raw-output '.[1].activeWorkspace.id' | tr -d '\\n'
socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | stdbuf -o0 awk -F '>>|,' '/^workspace>>/{print $2}'
