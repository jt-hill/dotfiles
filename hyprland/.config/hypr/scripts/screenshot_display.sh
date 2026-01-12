#!/bin/bash

output_id=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')
grim -o $output_id - | swappy -f -
