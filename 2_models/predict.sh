#!/bin/bash
root=~/bot/2_models

file=$1
name=${file##*/}
name=${name%_data.*}

data=$file
data_10=$root/../data/modeling/${name}_data_10.csv
head -n -10 $data | sed 's/nan/0/g' > $data_10 

labels=$root/../data/training/${name}_10_labels.csv 
labels_10=$root/../data/modeling/${name}_10_labels.csv
tail -n +11 $labels > $labels_10 

test_set=$root/../data/training/${name}_test.csv
tail -n 10 $data | sed 's/nan/0/g' > $test_set

train_size=`cat $data_10 | wc -l`
if [[ $train_size -gt 3 ]]
then
  norm_model=$root/../data/modeling/${name}_norm_model.txt
  echo -n > $norm_model

  data_10_norm=$root/../data/modeling/${name}_data_10_norm.csv
  mlpack_preprocess_scale -a min_max_scaler -e 2 -b -2 \
    --input_file $data_10 \
    --output_file $data_10_norm \
    --output_model_file $norm_model

  labels_10_norm=$root/../data/modeling/${name}_10_labels_norm.csv
  mlpack_preprocess_scale -a min_max_scaler -e 2 -b -2 \
    --input_file $labels_10 \
    --output_file $labels_10_norm 

  test_set_norm=$root/../data/modeling/${name}_test_norm.csv
  mlpack_preprocess_scale -a min_max_scaler -e 2 -b -2 \
    --input_model_file $norm_model \
    --input_file $test_set \
    --output_file $test_set_norm 

  pred_file=$root/../data/predicts/${name}.csv  

  mlpack_perceptron --max_iterations 100000 \
    --labels_file $labels_10_norm \
    --training_file $data_10_norm \
    --test_file $test_set_norm \
    --predictions_file $pred_file 


cat $pred_file | tr -d '\n' > ${pred_file}.tmp
echo -n -e "$name      \t" > $pred_file
cat ${pred_file}.tmp >> $pred_file
echo >> $pred_file
rm ${pred_file}.tmp
fi
