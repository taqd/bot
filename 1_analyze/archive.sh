#file: archive.sh

root=~/bot/1_analyze
data=$root/../data
raw=$data/raw
analysis=$data/analysis
forecast=$data/forecast
targets=$data/targets
archive=$data/archive

age=`cat $data/state/age`

if [[ ${age} -gt 1 ]]
then
  find ${raw}      -type f -print0 | xargs -0 -n 1000 -P 16 $root/simple.sh &
  find ${analysis} -type f -print0 | xargs -0 -n 1000 -P 16 $root/simple.sh &
  find ${forecast} -type f -print0 | xargs -0 -n 1000 -P 16 $root/simple.sh &
  wait
  echo -n -e " \033[;35m\u2713\033[0m "  
else
  echo -n -e "\033[;36mX\033[0m "
fi
