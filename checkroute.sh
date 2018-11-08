#!/bin/bash

tmux new-session -d -s main
tmux new-window -tmain -n NET sudo mtr 8.8.8.8 -tezi 0.5 -s -1 -Q1 --ipinfo 1
tmux split-window -tmain:NET sudo nethogs
tmux select-window -tmain:0
