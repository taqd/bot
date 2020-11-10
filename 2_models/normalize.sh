#!/bin/bash
root=~/bot/2_models

for file in "$@"
do
  name=${file##*/}
  name=${name%_data.*}
  # tail -n -10 data | sed 's/nan/0/g' > ../data/modeling/${name}_tmp.csv
  # head -n -10 targets > ../data/modeling/${target}_${window}
  # normalize targets

  datafile=$file
  label10=$root/../data/training/${name}_10_label.csv
  label60=$root/../data/training/${name}_60_label.csv
  label1440=$root/../data/training/${name}_1440_label.csv
  label10080=$root/../data/training/${name}_10080_label.csv

  mlpack_preprocess_scale -i $datafile -o ../data/modeling/${name}_normed.csv \
      -a min_max_scaler -e 2 -b -2
  mlpack_preprocess_scale -i $label10 -o ../data/modeling/${name}_normed.csv \
      -a min_max_scaler -e 2 -b -2
  mlpack_preprocess_scale -i $label60 -o ../data/modeling/${name}_normed.csv \
      -a min_max_scaler -e 2 -b -2
  mlpack_preprocess_scale -i $label1440 -o ../data/modeling/${name}_normed.csv \
      -a min_max_scaler -e 2 -b -2
  mlpack_preprocess_scale -i $label10080 -o ../data/modeling/${name}_normed.csv \
      -a min_max_scaler -e 2 -b -2




  #mlpack_perceptron -l ../data/training/XXBTZUSD_tick_askprice_10_labels.csv -t \
  #  ../data/modeling/${name}_normed.csv -T ../data/modeling/${name}_normed.csv -P \
  #    ../data/modeling/${name}_predictions.csv -n 100000
done
