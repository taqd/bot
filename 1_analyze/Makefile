all: build  

run:
	./analyze.sh
	./output.sh

build:
	mkdir -p ./bin
	clang++ -std=c++20 -O3 -lcurl ./src/create_outputs.cpp  -o ./bin/create_outputs

