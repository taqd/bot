all: prepare kraken 

run:
	./bin/judge_preds 

kraken:
	mkdir -p ./bin
	clang++ -std=c++20 -O3 -lcurl ./src/kraken_trade.cpp  -o ./bin/kraken_trade 
	clang++ -std=c++20 -O3 -lcurl ./src/kraken_spread.cpp -o ./bin/kraken_spread
	clang++ -std=c++20 -O3 -lcurl ./src/kraken_ohlc.cpp   -o ./bin/kraken_ohlc
	clang++ -std=c++20 -O3 -lcurl ./src/kraken_depth.cpp  -o ./bin/kraken_depth
	clang++ -std=c++20 -O3 -lcurl ./src/kraken_tick.cpp   -o ./bin/kraken_tick
	
prepare:
	mkdir -p ./bin
	clang++ -std=c++20 -O3 -lcurl ./src/prepare_raw.cpp   -o ./bin/prepare_raw

judge:
	mkdir -p ./bin
	clang++ -std=c++20 -O3 -lcurl ./src/judge_preds.cpp   -o ./bin/judge_preds
