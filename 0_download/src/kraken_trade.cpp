// file: kraken_trade.cpp
#include "../../libs/bot.hpp"

int main(int argc, char *argv[]) {
  string paircode{argv[1]},
         page{"https://api.kraken.com/0/public/Trades"}, 
         ret{""},
         page_opt{"pair="+paircode+"&since="+since_read(paircode+"_ohlc")},
         f{vector_dir + paircode + "_trade"},
         fr{raw_dir + paircode + "_trade_"};
  CURL* c = curl_easy_init();         if (!c) throw "bad curl init";
  try {
    if (!download_data(c, page, page_opt, ret)) throw "bad data download";
    json j{json::parse(ret)}; ret = "";
    if (!j["error"].empty()) throw "error data: " + j["error"].get<string>();

    int bm_count{0}, bl_count{0},  sm_count{0}, sl_count{0};
    vector<string> bm_price, bm_volume, bl_price, bl_volume,
      sm_price, sm_volume, sl_price, sl_volume;
    for (auto& [key, value] : j["result"][paircode].items()) {
      if (value[3].get<string>()=="b" && value[4].get<string>()=="m") {
        bm_price.push_back(value[0].get<string>()); 
        bm_volume.push_back(value[1].get<string>());
        bm_count+=1;
      }
      if (value[3].get<string>()=="b" && value[4].get<string>()=="l") {
        bl_price.push_back(value[0].get<string>()); 
        bl_volume.push_back(value[1].get<string>());
        bl_count+=1;
      }
      if (value[3].get<string>()=="s" && value[4].get<string>()=="m") {
        sm_price.push_back(value[0].get<string>()); 
        sm_volume.push_back(value[1].get<string>());
        sm_count+=1;
      }
      if (value[3].get<string>()=="s" && value[4].get<string>()=="l") {
        sl_price.push_back(value[0].get<string>()); 
        sl_volume.push_back(value[1].get<string>());
        sl_count+=1;
      }
    }

    check_and_save(f + "bmprice.csv",  bm_price);
    check_and_save(f + "bmvolume.csv", bm_volume);
    check_and_save(fr + "bmcount",  bm_count);
    check_and_save(f + "blprice.csv",  bl_price);
    check_and_save(f + "blvolume.csv", bl_volume);
    check_and_save(fr + "blcount",  bl_count);
    check_and_save(f + "smprice.csv",  sm_price);
    check_and_save(f + "smvolume.csv", sm_volume);
    check_and_save(fr + "smcount",  sm_count);
    check_and_save(f + "slprice.csv",  sl_price);
    check_and_save(f + "slvolume.csv", sl_volume);
    check_and_save(fr + "slcount",  sl_count);

  } 
  catch (const char* s) {
    cerr << ret << "\n\n";        
    print_symbol('E'); 
    return 0;}
  catch (string s) {
    cerr << s << " ::: " << ret << "\n\n";
    print_symbol('E');
    return 0;
  }
  catch (exception& e)  {
    cerr << e.what() << endl << ret << "\n\n"; 
    print_symbol('E'); 
    return 0;
  }
  print_symbol('X');
  return 0;
}
