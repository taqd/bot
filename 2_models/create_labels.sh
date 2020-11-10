#!/bin/bash
root=~/bot/2_models

for file in "$@"
do
  name=${file##*/}
  cat $root/../data/targets/$name >> $root/../data/training/${name}_labels
  echo >> $root/../data/training/${name}_labels
done
