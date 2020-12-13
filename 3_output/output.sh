#!/bin/bash

root=~/bot/1_analyze
data=$root/../data

header="on"

paircodes=$root/../settings/paircodes
function space {

echo -n "<span foreground='gray'>"
echo -n "|           |            |            |       |        |      |" 
echo -n "        |           |           |           |           |           |" 
echo  "           |      |      |      |      |      |      |" 


echo -n "</span>"
}

function header {

echo -n "<span foreground='gray'>taqd</span><span foreground='#FF00FF'>.</span><span
foreground='gray'>ca/kraken</span>"

echo -n "<span foreground='gray'>"
echo -n "----------------------------------------------------------" 
echo -n "---------------------------------------------------------" 
echo -n "---------------------------------------------------------" 
echo -n "</span>"
echo
}
function footer {

echo -n "<span foreground='gray'>"
echo -n "---------------------------------------------------------" 
echo -n "--------------------------------------------------------" 
echo -n "--------------------------------------------------------" 
echo -n "</span>"

time=`date +"%Y.%j.%H.%M.%S"`
echo -n "<span foreground='gray'>$time</span>"
echo
}
#header
./bin/create_outputs `cat $paircodes/BTC-AUD`   BTC-AUD   "on"
./bin/create_outputs `cat $paircodes/BTC-CAD`   BTC-CAD   "off" 
./bin/create_outputs `cat $paircodes/BTC-CHF`   BTC-CHF   "off" 
./bin/create_outputs `cat $paircodes/BTC-DAI`   BTC-DAI   "off" 
./bin/create_outputs `cat $paircodes/BTC-EUR`   BTC-EUR   "off" 
./bin/create_outputs `cat $paircodes/BTC-GBP`   BTC-GBP   "off" 
./bin/create_outputs `cat $paircodes/BTC-JPY`   BTC-JPY   "off" 
./bin/create_outputs `cat $paircodes/BTC-USDC`  BTC-USDC  "off" 
./bin/create_outputs `cat $paircodes/BTC-USDT`  BTC-USDT  "off" 
./bin/create_outputs `cat $paircodes/BTC-USD`   BTC-USD   "off" 
#space
./bin/create_outputs `cat $paircodes/ETH-XBT`   ETH-BTC   "off" 
./bin/create_outputs `cat $paircodes/ETH-AUD`   ETH-AUD   "off" 
./bin/create_outputs `cat $paircodes/ETH-CAD`   ETH-CAD   "off" 
./bin/create_outputs `cat $paircodes/ETH-CHF`   ETH-CHF   "off" 
./bin/create_outputs `cat $paircodes/ETH-DAI`   ETH-DAI   "off" 
./bin/create_outputs `cat $paircodes/ETH-EUR`   ETH-EUR   "off" 
./bin/create_outputs `cat $paircodes/ETH-GBP`   ETH-GBP   "off" 
./bin/create_outputs `cat $paircodes/ETH-JPY`   ETH-JPY   "off" 
./bin/create_outputs `cat $paircodes/ETH-USDC`  ETH-USDC  "off" 
./bin/create_outputs `cat $paircodes/ETH-USDT`  ETH-USDT  "off" 
./bin/create_outputs `cat $paircodes/ETH-USD`   ETH-USD   "off" 
#space
./bin/create_outputs `cat $paircodes/LTC-XBT`   LTC-BTC   "off" 
./bin/create_outputs `cat $paircodes/LTC-EUR`   LTC-EUR   "off" 
./bin/create_outputs `cat $paircodes/LTC-JPY`   LTC-JPY   "off" 
./bin/create_outputs `cat $paircodes/LTC-USD`   LTC-USD   "off" 
#space
./bin/create_outputs `cat $paircodes/RPL-XBT`   RPL-BTC   "off" 
./bin/create_outputs `cat $paircodes/RPL-CAD`   RPL-CAD   "off" 
./bin/create_outputs `cat $paircodes/RPL-EUR`   RPL-EUR   "off" 
./bin/create_outputs `cat $paircodes/RPL-JPY`   RPL-JPY   "off" 
./bin/create_outputs `cat $paircodes/RPL-USD`   RPL-USD   "off" 
#space
./bin/create_outputs `cat $paircodes/USDC-EUR`  USDC-EUR  "off" 
./bin/create_outputs `cat $paircodes/USDC-HF`   USDC-HF   "off" 
./bin/create_outputs `cat $paircodes/USDC-USDT` USDC-USDT "off" 
./bin/create_outputs `cat $paircodes/USDC-USD`  USDC-USD  "off" 
#space
./bin/create_outputs `cat $paircodes/USDT-AUD`  USDT-AUD  "off" 
./bin/create_outputs `cat $paircodes/USDT-CAD`  USDT-CAD  "off" 
./bin/create_outputs `cat $paircodes/USDT-CHF`  USDT-CHF  "off" 
./bin/create_outputs `cat $paircodes/USDT-EUR`  USDT-EUR  "off" 
./bin/create_outputs `cat $paircodes/USDT-GBP`  USDT-GBP  "off" 
./bin/create_outputs `cat $paircodes/USDT-JPY`  USDT-JPY  "off" 
./bin/create_outputs `cat $paircodes/USDT-USD`  USDT-USD  "off" 
#space
./bin/create_outputs `cat $paircodes/EUR-AUD`   EUR-AUD   "off" 
./bin/create_outputs `cat $paircodes/EUR-CAD`   EUR-CAD   "off" 
./bin/create_outputs `cat $paircodes/EUR-CHF`   EUR-CHF   "off" 
./bin/create_outputs `cat $paircodes/EUR-GBP`   EUR-GBP   "off" 
./bin/create_outputs `cat $paircodes/EUR-JPY`   EUR-JPY   "off" 
#space
./bin/create_outputs `cat $paircodes/USD-CAD`   USD-CAD   "off" 
./bin/create_outputs `cat $paircodes/USD-JPY`   USD-JPY   "off" 
./bin/create_outputs `cat $paircodes/GBP-USD`   GBP-USD   "off" 
./bin/create_outputs `cat $paircodes/EUR-USD`   EUR-USD   "off" 
#footer
