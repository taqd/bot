
root=~/bot

download: 
	cd ${root}/0_download/ && make

analyze:
	cd ${root}/1_analyze/ && make

model:
	cd ${root}/2_models/ && make

output:
	cd ${root}/3_output/ && make

run:
	./bot 

clean:
	rm -f ${root}/0_download/bin/*
	rm -f ${root}/1_analyze/bin/*
	rm -f ${root}/2_models/bin/*
	rm -f ${root}/3_output/bin/*
	rm -rf ${root}/data/*

go: clean download analyze output run
