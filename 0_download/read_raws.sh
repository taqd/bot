#!/bin/bash

echo -n -e " | "
root=~/bot/0_download
data=$root/../data
raw=$data/raw

find ${raw} -type f -printf "%f\n" | xargs -n 1 -P 32 $root/bin/prepare_raw 
echo -n -e "| parse: \033[;31m\u2713\033[0m"  
