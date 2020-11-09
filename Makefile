
root=~/bot

all: download

download: 
	cd ${root}/0_download/ && make

run:
	./bot 

clean:
	rm -f ${root}/0_download/bin/*
	rm -rf ${root}/data/*

go: clean download run
