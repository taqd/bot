#!/bin/bash

root=~/bot/2_models
age=`cat $root/../data/state/age`
echo -n "| model: "
if [[ ${age} -gt 11 ]]
then
  find ../data/windows/ -type f -print0 | xargs -0 -n 100 -P 16 ./create_training.sh 
  echo -n -e " \033[;31m\u2713\033[0m "  
else
  echo -n -e " \033[;36mX\033[0m "
fi
