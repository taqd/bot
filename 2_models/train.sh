#!/bin/bash
root=~/bot/2_models

for datum_file in "$@"
do

  name=${datum_file##*/}

  train_all=$root/../static_data/modeling/${name}_train.csv
  labels_all=$root/../static_data/modeling/${name}_labels.csv

  train_norm=$root/../data/modeling/${name}_train_norm.csv
  labels_norm=$root/../data/modeling/${name}_labels_norm.csv

  norm_model=$root/../data/modeling/${name}_norm_model.json
  perc1_model=$root/../data/modeling/${name}_perc1_model.json


  if [[ ! -f $perc1_model ]]
  then
    echo "training new model for $perc1_model"
    mlpack_preprocess_scale -a min_max_scaler -e 1 -b 0 \
      --input_file $train_all                           \
      --output_file $train_norm                         \
      --output_model_file $norm_model

    mlpack_preprocess_scale -a min_max_scaler -e 1 -b 0 \
      --input_model_file $norm_model                    \
      --input_file $labels_all                          \
      --output_file $labels_norm 

    mlpack_perceptron --max_iterations 100000           \
      --training_file $train_norm                       \
      --labels_file $labels_norm                        \
      --output_model_file $perc1_model

  else
    echo "updating model $perc1_model"
    mlpack_perceptron --max_iterations 100000           \
      --input_model_file $perc1_model                   \
      --labels_file $labels_norm                        \
      --training_file $train_norm                       \
      --output_model_file $perc1_model 2> /dev/null

    if [[ $? -gt 0 ]] 
    then
      echo "failed live train, re-normalizing"
      rm $per1_model $labels_norm $train_norm $norm_model
    fi
  fi
done
exit 0
