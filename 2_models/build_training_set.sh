#!/bin/bash
root=~/bot/2_models
age=`cat $root/../data/state/age`

function create_training {
  for file in $root/../data/raw/$1_*
  do
    cat $file >> $root/../data/training/$1
  done
  for file in $root/../data/analysis/$1_*
  do
    cat $file >> $root/../data/training/$1
  done
  for file in $root/../data/forecast/$1_*
  do
    cat $file >> $root/../data/training/$1
  done
  echo >> $root/../data/training/$1
 }


echo -n -e " | model: "

for window in $root/../data/windows/*
do
  create_training ${window##*/} 
done

if [[ ${age} -gt 11 ]]
then

  for window in $root/../data/windows/*  
  do
    cat $root/../data/targets/$1_target >> $root/../data/training/$1_labels
    echo >> $root/../data/training/$1_labels
  done

fi

echo -n -e " \033[;31m\u2713\033[0m "  
#find ../data/windows/ -type f -print0 | xargs -0 -n 100 -P 16 ./create_training.sh 
