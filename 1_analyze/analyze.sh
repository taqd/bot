#!/bin/bash

root=~/bot/1_analyze
data=$root/../data
age=`cat $data/state/age`

function base_analysis {
  find ../data/windows -type f -print0 | \
    xargs -0 -n 100 -P 8 python3 src/base_analysis.py
  echo -n "*"
}

function forecast {
  find ../data/windows/*_tick_askprice_* -type f -print0 | \
    xargs -0 -n 3 -P 64 python3 src/forecast.py 
  echo -n "*"
}

function write_out {
  find ../data/raw/ -type f -printf "%f\0" | \
    xargs -0 -n 50 -P 8 ./output.sh
  echo -n "*"
}

function create_streams {
  ./create_stream1.sh
  echo -n "*"
}


echo -n " | analyze: "
if [[ ${age} -gt 2 ]]
then
  base_analysis & 
  forecast &
else
  echo -n "X"
fi

wait

echo
echo -n " | output: "
if [[ ${age} -gt 2 ]]
then
  write_out
  create_streams
else
  echo -n "X"
fi
