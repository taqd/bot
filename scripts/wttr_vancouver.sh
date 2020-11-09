while true
do
  curl v2.wttr.in/Vancouver 2>/dev/null | head -n 43
  curl wttr.in/Vancouver?format="%C+|+temp:+%t(%f)+|+rain:+%p+|+humidity:+%h+|+barometer:+%P+|+wind:+%w+|+lunar:+%M+|\n" > ~/bot/scripts/left.txt 2> /dev/null
  curl wttr.in/Vancouver?format="|+dawn:+%D+|+sunrise:+%S+|+zenith:+%z+|+sunset:+%s+|+dusk:+%d" >  ~/bot/scripts/right.txt 2> /dev/null
  sleep 300
done
