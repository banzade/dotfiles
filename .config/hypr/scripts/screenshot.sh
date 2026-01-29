#!/bin/bash
pkill slurp
SELECTION=$(slurp -d) && grim -g "$SELECTION" - | tee ~/Pictures/screenshots/$(date +'screenshot_%Y%m%d_%H%M%S.png') | wl-copy
