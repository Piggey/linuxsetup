#!/usr/bin/env bash

filename="$HOME/Pictures/Screenshots/screenshot_$(date -Is).png"

# make sure ~/Pictures/Screenshots directories exist
# create one if not
if [ ! -d "~/Pictures/Screenshots" ]; 
then
    mkdir -p ~/Pictures/Screenshots
fi

# make screenshot and save
scrot -l mode=edge,width=3,color="#5e81ac" -s $filename

# save to clipboard
xclip -sel c -t image/png -i $filename 

