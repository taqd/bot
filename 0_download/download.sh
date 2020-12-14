#!/bin/bash

timeout=10s


root=~/bot/0_download
data=${root}/../data

echo -n " | download: "
codes=`cat $root/../settings/paircodes/*`
 
function tick {
  SECONDS=0
  cat $root/../settings/paircodes/* | timeout $timeout xargs -n 1 -P 4 $root/bin/kraken_tick \
    2> $data/state/errors_tick
  echo -n " tick $SECONDS "
}

function ohlc {
  SECONDS=0
 cat $root/../settings/paircodes/* |  timeout $timeout xargs -n 1 -P 4 $root/bin/kraken_ohlc \
    2> $data/state/errors_ohlc
  echo -n " ohlc $SECONDS "
}

function depth {
  SECONDS=0
  cat $root/../settings/paircodes/* | timeout $timeout  xargs -n 1 -P 4 $root/bin/kraken_depth \
    2> $data/state/errors_depth
  echo -n " depth $SECONDS "
}

function trade {
  SECONDS=0
  cat $root/../settings/paircodes/* | timeout $timeout  xargs -n 1 -P 4 $root/bin/kraken_trade \
    2> $data/state/errors_trade
  echo -n " trade $SECONDS "
}

function parse {
  SECONDS=0
  echo -n -e " | parse: "  
  files=`find $data/vectors/ -type f -empty -print`
  for file in $files; do 
    echo 0 > $file; 
  done
  echo -n "*"

  find $data/vectors -type f -not -empty -print0 \
    | xargs -0 -n 1 -P 8 $root/../bin/mlpack_preprocess_describe2 -i
  echo -n "*"
  
  find $data/raw -type f -printf "%f\n" \
    | xargs -n 1 -P 8 $root/bin/prepare_raw 
  echo -n "*"
  echo " $SECONDS "
}

tick &
depth &
trade &
wait
ohlc
echo -n "*"
echo

parse
