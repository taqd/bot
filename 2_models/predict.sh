#!/bin/bash
root=~/bot/2_models
age=`cat $root/../data/state/age`
datum_file=$1
name=${datum_file##*/}

datums=$root/../data/training/${name}_data.csv
targets=$root/../data/training/${name}_labels.csv

train_all=$root/../static_data/modeling/${name}_train.csv
labels_all=$root/../static_data/modeling/${name}_labels.csv

train_one=$root/../data/modeling/${name}_train.csv
labels_one=$root/../data/modeling/${name}_labels.csv
test_one=$root/../data/modeling/${name}_test.csv

train_norm=$root/../data/modeling/${name}_train_norm.csv
labels_norm=$root/../data/modeling/${name}_labels_norm.csv
test_norm=$root/../data/modeling/${name}_test_norm.csv

norm_model=$root/../data/modeling/${name}_norm_model.json
perc1_model=$root/../data/modeling/${name}_perc1_model.json

perc1_preds=$root/../data/predictions/${name}_perc1.csv
perc1_preds_norm=$root/../data/predictions/${name}_perc1_norm.csv

window=${datum_file##*_}
let windowplus1=window+1

targets_size=`cat $targets | wc -l`
let targets_size=targets_size-1
if [[ $targets_size -gt $window ]] # trim training window files
then
  tail -n +2 $datums  > ${datums}_tmp  && mv ${datums}_tmp  $datums
  tail -n +2 $targets > ${targets}_tmp && mv ${targets}_tmp $targets
fi

head -n -${window} $datums | tail -n 1 | sed 's/nan/0/g' > $train_one
tail -n +${windowplus1} $targets | tail -n 1 > $labels_one
tail -n 1 $datums | sed 's/nan/0/g' > $test_one

cat $train_one >> $train_all # update static training data
cat $labels_one >> $labels_all

one_size=`cat $labels_one | wc -l`
if [[ $one_size -eq 0 ]]
then
  exit
fi
all_size=`cat $labels_all | wc -l`
if [[ $all_size -lt 60 ]] 
then
  exit
fi

if [[ ! -f $perc1_model || $(( age % 15 )) == 0 ]]
then
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
  mlpack_preprocess_scale -a min_max_scaler -e 1 -b 0 \
    --input_model_file $norm_model                    \
    --input_file $train_one                           \
    --output_file $train_norm                         

  mlpack_preprocess_scale -a min_max_scaler -e 1 -b 0 \
    --input_model_file $norm_model                    \
    --input_file $labels_one                          \
    --output_file $labels_norm 

  mlpack_preprocess_scale -a min_max_scaler -e 1 -b 0 \
    --input_model_file $norm_model                    \
    --input_file $test_one                            \
    --output_file $test_norm 

  mlpack_perceptron --max_iterations 100000           \
    --input_model_file $perc1_model                   \
    --labels_file $labels_norm                        \
    --training_file $train_norm                       \
    --test_file $test_norm                            \
    --predictions_file $perc1_preds_norm              \
    --output_model_file $perc1_model

  mlpack_preprocess_scale -a min_max_scaler -e 1 -b 0 \
    --input_model_file $norm_model                    \
    --input_file $perc1_preds_norm                    \
    --output_file $perc1_preds                        \
    --inverse_scaling

fi
