split-pane -h -p 75
split-pane -h -p 60


send-keys -t 0 "~/bot/scripts/watch_dirs.sh" Enter
send-keys -t 1 "cd ~/bot/ && edit" Enter
send-keys -t 2 "clear" Enter

resize-pane -t 0 -x 67 -y 10
resize-pane -t 1 -x 208 -y 10

