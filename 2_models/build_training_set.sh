#!/bin/bash
root=~/bot/2_models

echo -n -e " | model: "
function create_training {
  echo > $root/../data/training/$1
  for file in $root/../data/archive/$1_*
  do
    cat $file | awk 'NF{NF-=10};1' >> $root/../data/training/$1
    echo >> $root/../data/training/$1
  done
  cat $root/../data/targets/$1_target | cut -f11- >> $root/../data/training/$1
  echo >> $root/../data/training/$1
}

for window in $root/../data/windows/*
do
  create_training ${window##*/} & 
done


