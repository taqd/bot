#!/bin/bash
root=~/bot/2_models

age=`cat $root/../data/state/age`

for window_file in "$@"
do

  datum_name=${window_file##*/}
  paircode=${datum_name%_*_*_*}
  datatype=${datum_name%_*}
  datatype=${datatype##*_}

  name_file=$root/../static_data/modeling/${datum_name}_names.csv
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

  ./predict.sh $window_file
done
