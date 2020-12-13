#!/bin/bash
root=~/bot/2_models
data=$root/../data
paircode=$1


failed_trains=0
count=0
SECONDS=0

while read -r datum; do
  window=${datum##*_}
  let windowplus1=window+1
  labels=$root/../data/labels/${datum}.csv
  labels_tmp=$root/../data/labels/${datum}_tmp.csv
  tail -n +${windowplus1} $labels > $labels_tmp
done < $data/state/${paircode}_labels

train=$root/../data/training/${paircode}_data.csv 
for win in $root/../settings/windows/*; do
  window=`cat $win`
  head -n -${window} $train > ${train}_${window}.csv
done

while read -r datum; do

  depth=$root/../data/modeling/${datum}_turing_depth
  if [[ ! -f $depth ]]; then
    echo 0 > $root/../data/modeling/${datum}_turing_depth
  fi
  depth=`cat $depth`

  size=$root/../data/modeling/${datum}_turing_size
  if [[ ! -f $size ]]; then
    echo 20 > $root/../data/modeling/${datum}_turing_size
  fi
  size=`cat $size`

  gain=$root/../data/modeling/${datum}_turing_gain
  if [[ ! -f $gain ]]; then
    echo "0.00001" > $root/../data/modeling/${datum}_turing_gain
  fi
  gain=`cat $gain`

  window=${datum##*_}
  labels_tmp=$root/../data/labels/${datum}_tmp.csv
  model=$root/../data/modeling/${datum}_turing.json
  
  if [[ -s ${train}_${window}.csv ]]; then
    mlpack_decision_tree \
    --maximum_depth $depth \
    --minimum_leaf_size $size \
    --minimum_gain_split $gain \
    --training_file ${train}_${window}.csv \
    --labels_file $labels_tmp \
    --output_model_file $model  || let failed_trains=failed_trains+1
    let count=count+1
  fi
done < $data/state/${paircode}_labels

echo "$paircode - $count models trained, $failed_trains failed, in $SECONDS seconds"

