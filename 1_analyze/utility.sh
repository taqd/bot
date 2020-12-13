#!/bin/bash



root=~/bot/1_analyze
data=$root/../data
datum=$1

datum=${datum%.*}
datum_short=${datum%_*}

window=${datum##*_}
windowplus1=$((window+1))

labels=$root/../data/labels/${datum}
labels_tmp=$root/../data/labels/.${datum}

cat $data/targets/$datum >> $data/labels/$datum 
echo >> $data/labels/$datum

tail -n +${windowplus1} $labels > $labels_tmp

for file in $data/forecast/${datum_short}_${window}*; do
  model_name=`basename $file`
  cat $file >> $data/predictions/$model_name
  echo >> $data/predictions/$model_name
  head -n -${window} $data/predictions/$model_name > $data/predictions/.$model_name
  if [ -s $data/predictions/.$model_name ]; then
    if [ -s $data/labels/.$datum ]; then
      ./bin/calc_util $data/labels/.$datum $data/predictions/.$model_name \
        > $data/utility/$model_name
    fi
  fi
done



#    tail -n 100 $data/predictions/$datum > $data/predictions/.$datum
#    mv $data/predictions/.$datum $data/predictions/$datum
#
#    tail -n 100 $data/labels/$datum > $data/labels/.$datum
#    mv $data/labels/.$datum $data/abels/$datum


