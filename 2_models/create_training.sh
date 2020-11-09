#!/bin/bash

root=~/bot/2_models

function create_training {
  echo -n > $root/../data/training/$1.csv
  for file in $root/../data/archive/${1}_*
  do
    #echo -n -e "${file##*/} " >> $root/../data/training/$1 
    awk 'NF{NF-=10};1' 2> /dev/null $file | sed 's/nan/0/g' | sed 's/ /\t/g' >> $root/../data/training/$1.csv
  done
  #echo -n -e "target " >> $root/../data/training/$1
  cut -f11- $root/../data/targets/$1_target 2> /dev/null | sed 's/ /\t/g' > $root/../data/training/$1_target.csv
}

for window in "$@"
do
  create_training ${window##*/} 
done


