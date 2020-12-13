#!/bin/bash

root=~/bot/1_analyze
data=$root/../data
age=`cat $data/state/age`

function base_analysis {
  SECONDS=0;
  find ../data/windows -type f -print0 | \
    xargs -0 -n 1 -P 32 ./$root/../bin/mlpack_preprocess_describe2 -f -i 
  echo -n " * base $SECONDS "
}

function forecast {
  SECONDS=0;
  find ../data/windows/ -name "*_tick_askprice_*" -type f -print0 | \
    xargs -0 -n 32 -P 8 python3 src/forecast.py 

  find ../data/windows/ -name "*_tick_askprice_*" -type f -printf "%f\n" \
    | xargs -n 1 -P 1 ./utility.sh 
  echo -n " * forecast $SECONDS "
}

echo -n " | analyze: "
if [[ ${age} -gt 2 ]]
then
#  base_analysis & 
  forecast 
else
  echo -n "X"
fi
wait


#echo
#echo -n " | output: "
#if [[ ${age} -gt 2 ]]
#then
#  write_out
#  create_streams
#else
#  echo -n "X"
#fi
#function write_out {
#  find ../data/raw/ -type f -printf "%f\0" | \
#    xargs -0 -n 50 -P 8 ./output.sh
#  echo -n "*"
#}
#
#function create_streams {
#  ./create_stream1.sh
#  echo -n "*"
#}
#
#
##  find ../data/windows -type f -print0 | \
#    xargs -0 -n 100 -P 8 python3 src/base_analysis.py

