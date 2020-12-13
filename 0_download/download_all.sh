#!/bin/bash


function go_a {
  ssh  -i /home/tyler/.ssh/google_compute_engine tyler@35.203.59.152 'cd bot; make run' 
  echo -n "*"
}

function go_b {
  ssh  -i /home/tyler/.ssh/google_compute_engine tyler@35.203.102.248 'cd bot; make run' 
  echo -n "*"
}

echo -n " | downloading all:"
go_a &
go_b &
wait
echo " *"
