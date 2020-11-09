#!/bin/bash

codes="EURCAD EURCHF EURGBP EURJPY ZEURZUSD ZGBPZUSD ZUSDZCAD ZUSDZJPY XETHZCAD XETHZEUR XETHZJPY XETHZUSD XXBTZCAD XXBTZEUR XXBTZJPY XXBTZUSD"

root=~/bot/0_download
data=${root}/../data

echo -n " | kraken: "
$root/bin/kraken_tick   $codes 2>> $data/state/runtime_errors &  
$root/bin/kraken_ohlc   $codes 2>> $data/state/runtime_errors & 
$root/bin/kraken_depth  $codes 2>> $data/state/runtime_errors & 
$root/bin/kraken_spread $codes 2>> $data/state/runtime_errors & 
$root/bin/kraken_trade  $codes 2>> $data/state/runtime_errors & 
wait
