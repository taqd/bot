#!/bin/bash

cd ~/bot/data
for file in *.tar
do
  echo $file
  tar -xf $file
done
