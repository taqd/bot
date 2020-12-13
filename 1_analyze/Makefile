all: build  

run:
	./analyze.sh
	./parse.sh

build:
	mkdir -p ./bin
	clang++ -std=c++20 -O3 -lcurl ./src/calc_util.cpp  -o ./bin/calc_util

