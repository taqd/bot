
  find ../data/windows/ -type f -print0 | xargs -0 -n 100 -P 1 ./train.sh 2> /dev/null 
