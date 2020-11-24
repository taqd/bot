#!/bin/bash

codes="XETHZCAD XETHZEUR XETHZUSD \
       XXBTZCAD XXBTZEUR XXBTZUSD \
       XETHXXBT"
#codes="EURCAD ZEURZUSD ZUSDZCAD XETHZCAD XETHZEUR XETHZUSD XXBTZCAD XXBTZEUR XXBTZUSD XETHXXBT"

#codes="EURCAD EURCHF EURGBP EURJPY ZEURZUSD ZGBPZUSD ZUSDZCAD ZUSDZJPY XETHZCAD XETHZEUR XETHZJPY XETHZUSD XXBTZCAD XXBTZEUR XXBTZJPY XXBTZUSD"

root=~/bot/0_download
data=${root}/../data

echo -n " | download: "
$root/bin/kraken_tick   $codes 2>> $data/state/runtime_errors &  
$root/bin/kraken_ohlc   $codes 2>> $data/state/runtime_errors & 
$root/bin/kraken_depth  $codes 2>> $data/state/runtime_errors & 
$root/bin/kraken_spread $codes 2>> $data/state/runtime_errors & 
$root/bin/kraken_trade  $codes 2>> $data/state/runtime_errors & 
wait

echo
echo -n -e " | parse: "  
find $data/raw -type f -printf "%f\n" | xargs -n 1 -P 32 $root/bin/prepare_raw > /dev/null 
echo -n "*"
