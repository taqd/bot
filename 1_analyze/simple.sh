root=~/bot/1_analyze
data=$root/../data
archive=$data/archive

for file in "$@"
do
  name="${file##*/}"
  cat $file >> ${archive}/${name}
  echo -n '\t' >> ${archive}/${name}
done
