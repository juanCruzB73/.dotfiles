#!/bin/bash
current_layout=$(setxkbmap -query | grep layout | awk '{print $2}')
if [ "$current_layout" == "latam" ]; then
    setxkbmap us
else
    setxkbmap latam
fi

