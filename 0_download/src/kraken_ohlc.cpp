// file: kraken_ohlc.cpp
#include "../../libs/bot.hpp"

int main(int argc, char *argv[]) {
  string page{"https://api.kraken.com/0/public/OHLC"}, ret{""};
  vector<string> paircodes; for (int i = 1; i < argc; ++i) paircodes.push_back(string{argv[i]});

  CURL* c = curl_easy_init(); if (!c) throw "bad curl init";
  for (string paircode : paircodes) {
    string page_opt{"pair=" + paircode + "&since=" + since_read(paircode + "_ohlc")},
           f{raw_dir + paircode + "_ohlc_"}; 
    try {
      if (!download_data(c, page, page_opt, ret)) throw "bad data download";
      json j{json::parse(ret)}; ret = "";
      if (!j["error"].empty()) throw "error data: " + j["error"].get<string>();

      float ohlc_open{0}, ohlc_high{0}, ohlc_low{0},   ohlc_close{0},
            ohlc_vmap{0}, ohlc_vol{0},  ohlc_count{0}, scale{0};

      for (auto& [key, value] : j["result"][paircode].items()) {
        ohlc_open += stof(value[1].get<string>());
        ohlc_high += stof(value[2].get<string>());
        ohlc_low  += stof(value[3].get<string>());
        ohlc_close+= stof(value[4].get<string>());
        ohlc_vmap += stof(value[5].get<string>());
        ohlc_vol  += stof(value[6].get<string>());
        ohlc_count+= value[7].get<int>();
        scale += 1;
      }
      ohlc_open = (scale==0) ? 0 : ohlc_open / scale;
      ohlc_high = (scale==0) ? 0 : ohlc_high / scale;
      ohlc_low  = (scale==0) ? 0 : ohlc_low  / scale;
      ohlc_close= (scale==0) ? 0 : ohlc_close/ scale;
      ohlc_vmap = (scale==0) ? 0 : ohlc_vmap / scale;
      ohlc_vol  = (scale==0) ? 0 : ohlc_vol  / scale;
      ohlc_count= (scale==0) ? 0 : ohlc_count/ scale;
      check_and_save(f + "openprice",  ohlc_open);
      check_and_save(f + "highprice",  ohlc_high);
      check_and_save(f + "lowprice",   ohlc_low);
      check_and_save(f + "closepric", ohlc_close);
      check_and_save(f + "volumemap",  ohlc_vmap);
      check_and_save(f + "volprice",   ohlc_vol);
      check_and_save(f + "count",      ohlc_count);

      since_write(paircode + "_ohlc", to_string(j["result"]["last"].get<long>()));

      if (DB>0)
        cout << fixed << setprecision(2) << paircode << "   " 
          << "\t open:" << ohlc_open
          << "\t high:" << ohlc_high
          << "\t low:" << ohlc_low
          << "\t close:" << ohlc_close
          << "\t vmap:" << ohlc_vmap
          << "\t vol:" << ohlc_vol
          << "\t num:" << ohlc_count << endl;
    }
    catch (const char* s) {cerr << ret << "\n\n";                     print_symbol('E'); }
    catch (exception& e)  {cerr << e.what() << endl << ret << "\n\n"; print_symbol('E'); }
  }
  print_symbol('O');
  return 0;
}
