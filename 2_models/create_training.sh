#!/bin/bash
root=~/bot/2_models

age=`cat $root/../data/state/age`

for datum_file in "$@"
do

  datum_name=${datum_file##*/}
  paircode=${datum_name%_*_*}
  datatype=${datum_name%_*}
  datasrc=${datatype%_*}
  datasrc=${datatype##*_}
  dataname=${datum_name##*_}
  datatype="${datasrc}_${dataname}"

  name_file=$root/../data/training/${datum_name}_names.csv
  training_file=$root/../data/training/${datum_name}_data.csv
  let once=1
  for datum_file in $root/../data/raw/${paircode}_*
  do
    if [[ $age -eq 3 ]]
    then
      echo $datum_file >> $name_file  
    fi
    if [[ $once -eq 1 ]]
    then
      let once=0
    else
      echo -n -e ", " >> $training_file 
    fi
    cat $datum_file >> $training_file 
  done

  let once=1
  for datum_file in $root/../data/raw/*_${datatype}
  do
    if [[ $age -eq 3 ]]
    then
      echo $datum_file >> $name_file 
    fi
    if [[ $once -eq 1 ]]
    then
      let once=0
    else
      echo -n -e ", " >> $training_file
    fi
    cat $datum_file >> $training_file   
  done

  let once=1
  for datum_file in $root/../data/analysis/${datum_name}_*
  do
    if [[ $age -eq 3 ]]
    then
      echo $datum_file >> $name_file  
    fi
    if [[ $once -eq 1 ]]
    then
      let once=0
    else
      echo -n -e ", " >> $training_file
    fi
    cat $datum_file >> $training_file   
  done

  let once=1
  for datum_file in $root/../data/forecast/${datum_name}_*
  do
    if [[ -f $datum_file ]]
    then
      if [[ $age -eq 3 ]]
      then
        echo $datum_file >> $name_file  
      fi
      if [[ $once -eq 1 ]]
      then
        let once=0
      else
        echo -n -e ", " >> $training_file
      fi
      cat $datum_file  >> $training_file
    fi
  done
  echo >> $training_file 

  ./predict.sh $training_file  
done

##find ../data/windows/ -type f -print0 | xargs -0 -n 100 -P 16 ./create_training.sh 
#root=~/bot/2_models
#
#function create_training {
#  echo -n > $root/../data/training/$1.csv
#  for datum_file in $root/../data/archive/${1}_*
#  do
#    #echo -n -e "${file##*/} " >> $root/../data/training/$1 
#    awk 'NF{NF-=10};1' 2> /dev/null $datum_file | sed 's/nan/0/g' >> $root/../data/training/$1.csv
#  done
#  #echo -n -e "target " >> $root/../data/training/$1
#  cut -f11- $root/../data/targets/$1_target 2> /dev/null > $root/../data/training/$1_target.csv
#}
#
#for window in "$@"
#do
#  create_training ${window##*/} 
#done
#
#
