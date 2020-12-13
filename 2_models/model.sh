#!/bin/bash
codes="XETHZCAD XETHZEUR XETHZUSD XXBTZCAD XXBTZEUR XXBTZUSD XETHXXBT"

training_age=1440
root=~/bot/2_models
age=`cat $root/../data/state/age`

function update_predictions {
  paircode=$1
  rand=$2
  if [[ $age -gt $training_age ]]; then
    while read -r datum; do
      pred_out=$root/../data/predictions/${datum}_turing
      sed "${rand}d" $pred_out > ${pred_out}_tmp
      mv ${pred_out}_tmp ${pred_out}
    done < ../data/state/${paircode}_labels
  fi
}

function update_labels {
  paircode=$1
  rand=$2
  if [[ ! -f ../data/state/${paircode}_labels ]]; then
    find ../data/targets/ -name "${paircode}_tick_askprice_*" -type f -printf "%f\n" \
      > ../data/state/${paircode}_labels
  fi
  if [[ $age -gt $training_age ]]; then
    while read -r datum; do
      sed "${rand}d" ../data/labels/$datum.csv > ../data/labels/${datum}.tmp
      mv ../data/labels/${datum}.tmp ../data/labels/${datum}.csv
    done < ../data/state/${paircode}_labels
  fi
#  while read -r datum; do
#    cat ../data/targets/$datum >> ../data/labels/${datum}.csv
#    echo >> ../data/labels/${datum}.csv
#  done < ../data/state/${paircode}_labels
  
  update_predictions $paircode $rand
}

function update_training {
  paircode=$1
  rand=$2
  if [[ ! -f ../data/state/${paircode}_train ]];  then
    find ../data/analysis/ -name "${paircode}_*" -type f -print > ../data/state/${paircode}_train
    find ../data/forecast/ -name "${paircode}_*" -type f -print >> ../data/state/${paircode}_train
  fi
  if [[ $age -gt $training_age ]]; then
    sed "${rand}d" ../data/training/${paircode}_data.csv > ../data/training/${paircode}_data.tmp 
    mv ../data/training/${paircode}_data.tmp  ../data/training/${paircode}_data.csv
  fi
  let once=1
  while read -r line;  do
    if [[ $once -eq 1 ]]; then
      let once=0
    else
      echo -n -e ", " >> ../data/training/${paircode}_data.csv
    fi
    sed "s/nan/0/" $line >> ../data/training/${paircode}_data.csv
  done < ../data/state/${paircode}_train
  echo >> ../data/training/${paircode}_data.csv

  update_labels $paircode $rand  
  echo -n -e "*"  
}

function predict {
  paircode=$1
  ./src/turing_predict.sh $paircode
  echo -n "*"
}
exit
echo -n " | model: "
if [[ ${age} -gt 2 ]]
then
  for paircode in $codes; do
    #rand=$(( ( RANDOM % ( training_size - 3) ) + 1 )) 
    rand=1
    update_training $paircode $rand  &
  done
  wait

  echo
  echo -n " | predict: "
  for paircode in $codes; do
    predict $paircode 2> $root/../data/state/runtime_errors & 
  done
  wait

else
  echo -n -e "X"
fi
