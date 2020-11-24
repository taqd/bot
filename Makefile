
root=~/bot

all: download analyze

download: 
	cd ${root}/0_download/ && make

analyze:
	cd ${root}/1_analyze/ && make

run:
	./bot 

clean:
	rm -f ${root}/0_download/bin/*
	rm -rf ${root}/data/*

go: clean download analyze run
