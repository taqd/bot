#!/bin/bash


function go_a {
  ssh  -i /home/tyler/.ssh/google_compute_engine tyler@35.203.99.79 'cd bot; make run' 
  echo -n "*"
}

function go_b {
  ssh  -i /home/tyler/.ssh/google_compute_engine tyler@35.203.12.212 'cd bot; make run' 
  echo -n "*"
}

function go_c {
  ssh  -i /home/tyler/.ssh/google_compute_engine tyler@34.69.202.219 'cd bot; make run' 
  echo -n "*"
}

function go_d {
  ssh  -i /home/tyler/.ssh/google_compute_engine tyler@34.125.85.148 'cd bot; make run' 
  echo -n "*"
}

echo -n " | downloading all:"
go_a &
go_b &
go_c &
go_d &
wait
echo " *"
