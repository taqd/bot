// file: kraken_ohlc.cpp
#include "../../libs/bot.hpp"

int main(int argc, char *argv[]) {
  string page{"https://api.kraken.com/0/public/OHLC"}, 
         ret{""}, 
         paircode{argv[1]},
         page_opt{"pair=" + paircode + "&since=" + since_read(paircode + "_ohlc")},
         f{raw_dir + paircode + "_ohlc_"}; 
  CURL* c = curl_easy_init(); if (!c) throw "bad curl init";
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
    //ohlc_vmap = (scale==0) ? 0 : ohlc_vmap / scale;
    //ohlc_vol  = (scale==0) ? 0 : ohlc_vol  / scale;
    //ohlc_count= (scale==0) ? 0 : ohlc_count/ scale;
    check_and_save(f + "openprice",  ohlc_open);
    check_and_save(f + "highprice",  ohlc_high);
    check_and_save(f + "lowprice",   ohlc_low);
    check_and_save(f + "closepric", ohlc_close);
    check_and_save(f + "volumemap",  ohlc_vmap);
    check_and_save(f + "volprice",   ohlc_vol);
    check_and_save(f + "count",      ohlc_count);

    since_write(paircode + "_ohlc", to_string(j["result"]["last"].get<long>()));
  }
  catch (const char* s) {
    cerr << ret << "\n\n";   
    print_symbol('E'); 
    return 0;
  }
  catch (exception& e)  {
    cerr << e.what() << endl << ret << "\n\n"; 
    print_symbol('E'); 
    return 0;}
  print_symbol('O');
  return 0;
}

