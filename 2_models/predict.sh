#!/bin/bash
root=~/bot/2_models
datum_file=$1
name=${datum_file##*/}

datums=$root/../data/training/${name}_data.csv
targets=$root/../data/training/${name}_labels.csv

train=$root/../data/modeling/${name}_train.csv
labels=$root/../data/modeling/${name}_labels.csv
testing=$root/../data/modeling/${name}_test.csv

train_norm=$root/../data/modeling/${name}_train_norm.csv
labels_norm=$root/../data/modeling/${name}_labels_norm.csv
testing_norm=$root/../data/modeling/${name}_test_norm.csv

norm_model=$root/../data/modeling/${name}_norm_model.json
perc1_model=$root/../data/modeling/${name}_perc1_model.json

perc1_preds=$root/../data/predictions/${name}_perc1.csv

window=${datum_file##*_}
let windowplus1=window+1

let training_size=window*2
tail -n $training_size $datums > ${datums}_tmp
mv ${datums}_tmp $datums
head -n -${window} $datums | sed 's/nan/0/g' > $train
tail -n 1 $datums | sed 's/nan/0/g' > $testing
train_size=`cat $train | wc -l`

tail -n $training_size $targets > ${targets}_tmp
mv ${targets}_tmp $targets
tail -n +${windowplus1} $targets > $labels 

if [[ $train_size -gt 0 ]]
then

  mlpack_preprocess_scale -a min_max_scaler -e 2 -b -2 \
    --input_file $train                                \
    --output_file $train_norm                          \
    --output_model_file $norm_model

  mlpack_preprocess_scale -a min_max_scaler -e 2 -b -2 \
    --input_model_file $norm_model                     \
    --input_file $labels                               \
    --output_file $labels_norm 

  mlpack_preprocess_scale -a min_max_scaler -e 2 -b -2 \
    --input_model_file $norm_model                     \
    --input_file $testing                              \
    --output_file $testing_norm 

  if [[ ! -f $perc1_model ]]
  then
    mlpack_perceptron --max_iterations 10000 \
      --labels_file $labels_norm            \
      --training_file $train_norm           \
      --test_file $testing_norm             \
      --predictions_file $perc1_preds       \
      --output_model_file $perc1_model

  else
    mlpack_perceptron --max_iterations 10000 \
      --input_model_file $perc1_model       \
      --labels_file $labels_norm            \
      --training_file $train_norm           \
      --test_file $testing_norm             \
      --predictions_file $perc1_preds_norm  \
      --output_model_file $perc1_model
  fi

#  mlpack_preprocess_scale -a min_max_scaler -e 2 -b -2 \
#    --input_model_file $norm_model                     \
#    --input_file $perc1_preds_norm                     \
#    --output_file $perc1_preds                         \
#    --inverse_scaling

fi



    #--input_model_file $perc1_model       \
