watch -c -t -n 1 'tree -a --filelimit 13 -C --dirsfirst -I .git ~/bot/ | cut -c -56; \
  cd ~/bot/; du -h ./data'
