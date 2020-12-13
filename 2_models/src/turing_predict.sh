#!/bin/bash
root=~/bot/2_models
age=`cat $root/../data/state/age`
paircode=$1

train=$root/../data/training/${paircode}_data.csv

while read -r datum; do

  model=$root/../data/modeling/${datum}_turing.json
  prediction_file=$root/../data/modeling/${datum}_turing_pred.csv
  if [[ -f $model ]]; then
    test_data=$root/../data/modeling/${datum}_turing_test.csv
    tail -n 1 $train | sed 's/nan/0/g' > $test_data
    mlpack_decision_tree \
      --input_model_file $model \
      --test_file $test_data \
      --predictions_file $prediction_file

  else
    echo 0 > $prediction_file
  fi
  pred_window=$root/../data/modeling/${datum}_turing_win
  cat $prediction_file >> $pred_window

  pred_out=$root/../data/predictions/${datum}_turing
  head -n 1 $pred_window >> $pred_out

  pred_win_size=`cat $pred_window | wc -l`
  window=${datum##*_}
  if [[ $pred_win_size -gt $window ]]; then
    tail -n +2 $pred_window > ${pred_window}_tmp
    mv ${pred_window}_tmp $pred_window
  fi

done < ../data/state/${paircode}_labels



  #window=${datum##*_}
  #let windowplus1=window+1
  #tail -n +${windowplus1} $labels | awk 'NR % 2 == 0' $labels_tmp > ${labels}_a
  #tail -n +${windowplus1} $labels | awk 'NR % 2 == 1' $labels_tmp > ${labels}_b

#tail -n 1 $train | sed 's/nan/0/g' > $test_one
#  window=${datum##*_}
#  let windowplus1=window+1
#  head -n -${window} $train | awk 'NR % 2 == 0' $train > ${train}_a
#  head -n -${window} $train | awk 'NR % 2 == 1' $train > ${train}_b


#  else
#    mlpack_decision_tree --max_iterations 10000            \
#      --input_model_file $model                   \
#      --labels_file $labels                        \
#      --training_file $train                       \
#      --test_file $test                            \
#      --predictions_file $preds              \
#      --output_model_file $model 
#
#  fi
#
# datums=$root/../data/training/${name}_data.csv
# targets=$root/../data/training/${name}_labels.csv
# 
# train_all=$root/../static_data/modeling/${name}_train.csv
# labels_all=$root/../static_data/modeling/${name}_labels.csv
# 
# train_one=$root/../data/modeling/${name}_train.csv
# labels_one=$root/../data/modeling/${name}_labels.csv
# test_one=$root/../data/modeling/${name}_test.csv
# 
# train_norm=$root/../data/modeling/${name}_train_norm.csv
# labels_norm=$root/../data/modeling/${name}_labels_norm.csv
# test_norm=$root/../data/modeling/${name}_test_norm.csv
# 
# train_norm_model=$root/../data/modeling/${name}_trainnorm_model.json
# labels_norm_model=$root/../data/modeling/${name}_labelsnorm_model.json
# perc1_model=$root/../data/modeling/${name}_perc1_model.json
# 
# perc1_preds=$root/../data/predictions/${name}_perc1.csv
# perc1_preds_norm=$root/../data/predictions/${name}_perc1_norm.csv
# 
# window=${datum_file##*_}
# let windowplus1=window+1
# 
# targets_size=`cat $targets | wc -l`
# let targets_size=targets_size-1
# if [[ $targets_size -gt $window ]] # trim training window files
# then
#   tail -n +2 $datums  > ${datums}_tmp  && mv ${datums}_tmp  $datums
#   tail -n +2 $targets > ${targets}_tmp && mv ${targets}_tmp $targets
# fi
# 
# head -n -${window} $datums | tail -n 1 | sed 's/nan/0/g' > $train_one
# tail -n +${windowplus1} $targets | tail -n 1 > $labels_one
# tail -n 1 $datums | sed 's/nan/0/g' > $test_one
# 
# cat $train_one >> $train_all # update static training data
# cat $labels_one >> $labels_all
# 
# one_size=`cat $labels_one | wc -l`
# if [[ $one_size -eq 0 ]]
# then
#   exit
# fi
# all_size=`cat $labels_all | wc -l`
# if [[ $all_size -lt 10 ]] 
# then
#   exit
# fi
# 
# 
