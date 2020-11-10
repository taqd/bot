#!/bin/bash
root=~/bot/2_models

age=`cat $root/../data/state/age`

for file in "$@"
do

  name=${file##*/}
  paircode=${name%_*_*}
  datatype=${name%_*}
  datasrc=${datatype%_*}
  datasrc=${datatype##*_}
  dataname=${name##*_}
  datatype="${datasrc}_${dataname}"

  let once=1
  for file in $root/../data/raw/${paircode}_*
  do
    if [[ ${age} -eq 3 ]]
    then
      echo $file >> $root/../data/training/${name}_names.csv
    fi
    if [[ $once -eq 1 ]]
    then
      let once=0
    else
      echo -n -e ", " >> $root/../data/training/${name}_data.csv
    fi
    cat $file >> $root/../data/training/${name}_data.csv
  done

  let once=1
  for file in $root/../data/raw/*_${datatype}
  do
    if [[ ${age} -eq 3 ]]
    then
      echo $file >> $root/../data/training/${name}_names.csv
    fi
    if [[ $once -eq true ]]
    then
      let once=0
    else
      echo -n -e ", " >> $root/../data/training/${name}_data.csv
    fi
    cat $file >> $root/../data/training/${name}_data.csv
  done

  let once=1
  for file in $root/../data/analysis/${name}_*
  do
    if [[ ${age} -eq 3 ]]
    then
      echo $file >> $root/../data/training/${name}_names.csv
    fi
    if [[ $once -eq true ]]
    then
      let once=0
    else
      echo -n -e ", " >> $root/../data/training/${name}_data.csv
    fi
    cat $file >> $root/../data/training/${name}_data.csv
  done

  let once=1
  for file in $root/../data/forecast/${name}_*
  do
    if [[ -f $file ]]
    then
      if [[ ${age} -eq 3 ]]
      then
        echo $file >> $root/../data/training/${name}_names.csv
      fi
      if [[ $once -eq true ]]
      then
        let once=0
      else
        echo -n -e ", " >> $root/../data/training/${name}_data.csv
      fi
      cat $file  >> $root/../data/training/${name}_data.csv
    fi
  done
  echo >> $root/../data/training/${name}_data.csv

done

##find ../data/windows/ -type f -print0 | xargs -0 -n 100 -P 16 ./create_training.sh 
#root=~/bot/2_models
#
#function create_training {
#  echo -n > $root/../data/training/$1.csv
#  for file in $root/../data/archive/${1}_*
#  do
#    #echo -n -e "${file##*/} " >> $root/../data/training/$1 
#    awk 'NF{NF-=10};1' 2> /dev/null $file | sed 's/nan/0/g' >> $root/../data/training/$1.csv
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
