// file: kraken_depth.cpp
#include "../../libs/bot.hpp"

int main(int argc, char *argv[]) {
  string page{"https://api.kraken.com/0/public/Depth"}, 
         ret{""},
         paircode{argv[1]},
         page_opt{"pair=" + paircode + "&count=10000"},
         f{vector_dir + paircode + "_depth"};
  CURL* c = curl_easy_init(); if (!c) throw "bad curl init";
  try {
    if (!download_data(c, page, page_opt, ret)) throw "bad data download";
    long since = stol(since_read(paircode + "_ohlc"));
    json j{json::parse(ret)}; ret = "";
    if (!j["error"].empty()) throw "error data: " + j["error"].get<string>();
    vector<float> ask_list, bid_list, ask_plist, bid_plist;
    for (auto& [key, value] : j["result"][paircode]["asks"].items()) {
      long inst_time = value[2].get<long>();
      if (inst_time < since) continue;
      float ask_price  = stof(value[0].get<string>()),
            ask_volume = stof(value[1].get<string>());
      ask_plist.push_back(ask_price);
      ask_list.push_back(ask_volume);
    }
    for (auto& [key, value] : j["result"][paircode]["bids"].items()) {
      long inst_time = value[2].get<long>();
      if (inst_time < since) continue;
      float bid_price = stof(value[0].get<string>()),
            bid_volume = stof(value[1].get<string>()); 
      bid_plist.push_back(bid_price);
      bid_list.push_back(bid_volume);
    }
    check_and_save(f + "askprice.csv",  ask_plist);
    check_and_save(f + "bidprice.csv",  bid_plist);
    check_and_save(f + "askvolum.csv", ask_list);
    check_and_save(f + "bidvolum.csv", bid_list);
  }
  catch (const char* s) {
    cerr << s << ret << "\n\n"; 
    print_symbol('E');
    return 0;
  }
  catch (exception& e)  {
    cerr << e.what() << endl << ret << "\n\n"; 
    print_symbol('E'); 
    return 0;
  }
  catch (...) {cerr << "shit dead"<< endl; }
  curl_easy_cleanup(c);

  print_symbol('D');
  return 0;
}


