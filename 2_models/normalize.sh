#!/bin/bash
root=~/bot/2_models

for file in "$@"
do
  name=${file##*/}
  mlpack_preprocess_scale -i $file -o ../data/modeling/${name}_normed.csv \
      -a min_max_scaler -e 2 -b -2

  #mlpack_perceptron -l ../data/training/XXBTZUSD_tick_askprice_10_labels.csv -t \
  #  ../data/modeling/${name}_normed.csv -T ../data/modeling/${name}_normed.csv -P \
  #    ../data/modeling/${name}_predictions.csv -n 100000
done
