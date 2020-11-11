#!/bin/bash

echo -n -e " | prep: "
for file in ../data/raw/*
do
  ./bin/prepare_raw `basename $file` & 
done
wait
echo -n -e "\033[;31m\u2713\033[0m"  
