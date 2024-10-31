#!/bin/bash
gnome-terminal --title="nvimunity" -- nvr --servername \
    "/tmp/nvimunity" --remote-silent $@ && \
    if command -v wmctrl > /dev/null; then wmctrl -F -a nvimunity; fi
