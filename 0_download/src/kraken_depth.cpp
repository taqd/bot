// file: kraken_depth.cpp
#include "../../libs/bot.hpp"

int main(int argc, char *argv[]) {
  string page{"https://api.kraken.com/0/public/Depth"}, ret{""};
  vector<string> paircodes; for (int i = 1; i < argc; ++i) paircodes.push_back(string{argv[i]});

  CURL* c = curl_easy_init(); if (!c) throw "bad curl init";
  for (string paircode : paircodes) {
    string page_opt{"pair=" + paircode + "&count=5"},
           f{raw_dir + paircode + "_depth_"};
    try {
      if (!download_data(c, page, page_opt, ret)) throw "bad data download";
      json j{json::parse(ret)}; ret = "";
      if (!j["error"].empty()) throw "error data: " + j["error"].get<string>();

      float ask_price{0}, ask_volume{0}, ask_scale{0},
            bid_price{0}, bid_volume{0}, bid_scale{0};
      for (auto& [key, value] : j["result"][paircode]["asks"].items()) {
        if (DB>1) cout << paircode << " ask#" << key << " " << value << endl;
        ask_price  += stof(value[0].get<string>());
        ask_volume += stof(value[1].get<string>());
        ask_scale += 1;
      }
      for (auto& [key, value] : j["result"][paircode]["bids"].items()) {
        if (DB>1) cout << paircode << " bid#" << key << " " << value << endl;
        bid_price  += stof(value[0].get<string>());
        bid_volume += stof(value[1].get<string>()); 
        bid_scale += 1;
      }
      ask_price  = (ask_scale==0) ? 0 : ask_price / ask_scale;
      bid_price  = (ask_scale==0) ? 0 : bid_price / ask_scale;
      check_and_save(f + "askprice",  ask_price);
      check_and_save(f + "bidprice",  bid_price);
      check_and_save(f + "askvolum", ask_volume);
      check_and_save(f + "bidvolum", bid_volume);

      if (DB>0)
        cout << fixed << setprecision(2) 
          << paircode << "   " << "\tasks:" << ask_price << "/" 
          << ask_volume << "\tbids:" << bid_price << "/" << bid_volume << endl;
    }
    catch (const char* s) {cerr << ret << "\n\n";                     print_symbol('E');}
    catch (exception& e)  {cerr << e.what() << endl << ret << "\n\n"; print_symbol('E');}
  }
  curl_easy_cleanup(c);

  print_symbol('D');
  return 0;
}
