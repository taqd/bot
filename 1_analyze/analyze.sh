#!/bin/bash


root=~/bot/1_analyze
data=$root/../data
age=`cat $data/state/age`

function base_analysis {
  find ../data/windows -mmin -1 -print0 | xargs -0 -n 600 -P 32 python3 src/base_analysis.py
}

function forecast {
  find ../data/windows/*tick_askprice_* -mmin -1 -print0 | xargs -0 -n 5 -P 32 python3 src/forecast.py 
}


SECONDS=0   

echo -n " |"
if [[ ${age} -gt 1 ]]
then
  base_analysis & 
  forecast &
  wait
  echo -n " analyzed: `find ../data/windows -mmin -1 | wc -l`"
  echo -n " forecasted: `find ../data/windows/*tick_askprice_* -mmin -1 | wc -l`"
  echo -n -e " \033[;36m\u2713\033[0m "
else
  echo -n -e " \033[;36mX\033[0m "
fi

let LEFT=60-SECONDS
echo -n -e " ${SECONDS}s "



