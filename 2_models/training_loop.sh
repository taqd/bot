#!/bin/bash
root=~/bot/2_models
data=$root/../data
train_status=$data/state/train_status

while true
do
  SECONDS=0
  find ../settings/paircodes -type f -printf "%f\0" \
    | xargs -0 -n 1 -P 1 ./src/turing_train.sh 2> ../data/state/runtime_errors 

  let left=20-SECONDS
  if [[ $left -gt 1 ]]; then
    echo "trained all in $SECONDS seconds - sleeping $left seconds"
    sleep $left
  else
    echo "trained all in $SECONDS seconds - not sleeping"
  fi

done
#  for paircode in $root/../settings/paircodes/*
#  do
#    paircode=`basename $paircode`
#    ./src/turing_train.sh $paircode 2> $root/../data/state/runtime_errors 
#  done
