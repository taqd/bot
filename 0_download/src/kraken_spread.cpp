// file: kraken_spread.cpp
#include "../../libs/bot.hpp"

int main(int argc, char *argv[]) {
  string page{"https://api.kraken.com/0/public/Spread"}, ret{""}; 
  vector<string> paircodes; for (int i = 1; i < argc; ++i) paircodes.push_back(string{argv[i]});

  CURL* c = curl_easy_init(); if (!c) throw "bad curl init";
  for (string paircode : paircodes) {
    string page_opt{"pair=" + paircode + "&since=" + since_read(paircode + "_spread")},
           f{raw_dir + paircode + "_spread_"};
    try {
      if (!download_data(c, page, page_opt, ret)) throw "bad data download";
      json j{json::parse(ret)}; ret = "";
      if (!j["error"].empty()) throw "error data: " + j["error"].get<string>();

      float spread_ask{0}, spread_bid{0}, scale{0};
      for (auto& [key, value] : j["result"][paircode].items()) {
        spread_ask += stof(value[1].get<string>());  
        spread_bid += stof(value[2].get<string>());  
        scale += 1;
      }
      spread_ask = (scale==0) ? 0 : spread_ask / scale;
      spread_bid = (scale==0) ? 0 : spread_bid / scale;
      check_and_save(f + "ask", spread_ask);
      check_and_save(f + "bid", spread_bid);

      since_write(paircode+"_spread", to_string(j["result"]["last"].get<long>()));

      if (DB>0) 
        cout << fixed << setprecision(2) << paircode 
          << "   \tspread ask: \t" << spread_ask << "\tspread bid: " << spread_bid << endl;
    }
    catch (const char* s) {cerr << ret << "\n\n";                     print_symbol('E'); return 0;}
    catch (exception& e)  {cerr << e.what() << endl << ret << "\n\n"; print_symbol('E'); return 0;}
  }
  print_symbol('S');
  return 0;
}
