#!/bin/bash
root=~/bot/2_models

for file in "$@"
do
  continue
  name=${file##*/}
  name=${name%_data.*}
  #tail -n -10 data | sed 's/nan/0/g' > ../data/modeling/${name}_tmp.csv
  # normalize targets

  data=$file
  data_10=$root/../data/modeling/${name}_data_10_norm.csv
  data_10_norm=$root/../data/modeling/${name}_data_10_norm.csv
  label_10=$root/../data/training/${name}_10_label.csv 
  label_10_train=$root/../data/modeling/${name}_10_label_train.csv
  label_10_norm=$root/../data/modeling/${name}_10_label_norm.csv
  label_10_pred=$root/../data/modeling/${name}_10_label_pred.csv

  head -n -10 $label_10 > $label_10_train
  tail -n -10 $data | sed 's/nan/0/g' > $data_10
  mlpack_preprocess_scale -i $data_10 -o $data_10_norm -a min_max_scaler -e 2 -b -2
  mlpack_preprocess_scale -i $label_10_train -o $label_10_norm -a min_max_scaler -e 2 -b -2
  mlpack_perceptron -l $label_10_norm -t $data_norm -T $data_norm -P $label_10_pred 
done
