split-pane -h
split-pane -h

select-pane -t 0 
split-pane -v
split-pane -v
select-pane -t 3
split-pane -v
select-pane -t 5
split-pane -v
split-pane -v 

send-keys -t 0 "cd bot && clear && ls" Enter
send-keys -t 1 "~/bot/scripts/fortune.sh" Enter
send-keys -t 2 "htop" Enter
send-keys -t 3 "vim" Enter
send-keys -t 4 "cmatrix -u 10" Enter
send-keys -t 5 "~/bot/scripts/wttr.sh" Enter
send-keys -t 6 "tload -d 10 -s 1" Enter
send-keys -t 7 "bmon" Enter

resize-pane -t 0 -x 100 -y 10
#resize-pane -t 1 -x 100 -y 20
resize-pane -t 2 -x 100 -y 50
resize-pane -t 3 -x 141 -y 63
#resize-pane -t 4 -x 100 -y 20
resize-pane -t 5 -x 78 -y 44
#resize-pane -t 6 -x 40 -y 20
resize-pane -t 7 -x 78 -y 26
