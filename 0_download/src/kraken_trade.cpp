// file: kraken_trade.cpp
#include "../../libs/bot.hpp"

int main(int argc, char *argv[]) {
  vector<string> paircodes; for (int i = 1; i < argc; ++i) paircodes.push_back(string{argv[i]});
  string page{"https://api.kraken.com/0/public/Trades"}, ret{""};                            

  CURL* c = curl_easy_init();         if (!c) throw "bad curl init";
  for (string paircode : paircodes) {
    string page_opt{"pair="+paircode+"&since="+since_read(paircode+"_trade")},
           f{raw_dir + paircode + "_trade_"};
    try {
      if (!download_data(c, page, page_opt, ret)) throw "bad data download";
      json j{json::parse(ret)}; ret = "";
      if (!j["error"].empty()) throw "error data: " + j["error"].get<string>();

      float bm_price{0}, bm_volume{0}, bl_price{0}, bl_volume{0},
            sm_price{0}, sm_volume{0}, sl_price{0}, sl_volume{0},
            bm_scale{0}, bl_scale{0},  sm_scale{0}, sl_scale{0};
      for (auto& [key, value] : j["result"][paircode].items()) {
        if (value[3].get<string>()=="b" && value[4].get<string>()=="m") {
          bm_price += stof(value[0].get<string>()); 
          bm_volume += stof(value[1].get<string>());
          bm_scale+=1;
        }
        if (value[3].get<string>()=="b" && value[4].get<string>()=="l") {
          bl_price += stof(value[0].get<string>()); 
          bl_volume += stof(value[1].get<string>());
          bl_scale+=1;
        }
        if (value[3].get<string>()=="s" && value[4].get<string>()=="m") {
          sm_price += stof(value[0].get<string>()); 
          sm_volume += stof(value[1].get<string>());
          sm_scale+=1;
        }
        if (value[3].get<string>()=="s" && value[4].get<string>()=="l") {
          sl_price += stof(value[0].get<string>()); 
          sl_volume += stof(value[1].get<string>());
          sl_scale+=1;
        }
      }
      bm_price  = (bm_scale == 0) ? 0 : bm_price  / bm_scale;
      bm_volume = (bm_scale == 0) ? 0 : bm_volume / bm_scale;
      bl_price  = (bl_scale == 0) ? 0 : bl_price  / bl_scale;
      bl_volume = (bl_scale == 0) ? 0 : bl_volume / bl_scale;
      sm_price  = (sm_scale == 0) ? 0 : sm_price  / sm_scale;
      sm_volume = (sm_scale == 0) ? 0 : sm_volume / sm_scale;
      sl_price  = (sl_scale == 0) ? 0 : sl_price  / sl_scale;
      sl_volume = (sl_scale == 0) ? 0 : sl_volume / sl_scale;
      check_and_save(f + "bmprice",  bm_price);
      check_and_save(f + "bmvolume", bm_volume);
      check_and_save(f + "bmcount",  bm_scale);
      check_and_save(f + "blprice",  bl_price);
      check_and_save(f + "blvolume", bl_volume);
      check_and_save(f + "blcount",  bl_scale);
      check_and_save(f + "smprice",  sm_price);
      check_and_save(f + "smvolume", sm_volume);
      check_and_save(f + "smcount",  sm_scale);
      check_and_save(f + "slprice",  sl_price);
      check_and_save(f + "slvolume", sl_volume);
      check_and_save(f + "slcount",  sl_scale);
      since_write(paircode + "_trade", j["result"]["last"].get<string>()); 

      if (DB>0) 
        cout << fixed << setprecision(2) << paircode << "   \t"
          << " buy market:"   << bm_price << "/" << bm_volume << "(" << bm_scale 
          << ") \tbuy limit::"  << bl_price << "/" << bl_volume << "(" << bl_scale 
          << "\tsell market:"  << sm_price << "/" << sm_volume << "(" << sm_scale 
          << ")\tsell limit::" << sl_price << "/" << sl_volume << "(" << sl_scale 
          << ")\n";
    } 
    catch (const char* s) {cerr << ret << "\n\n";                     print_symbol('E'); return 0;}
    catch (string s) {cerr << s << " ::: " << ret << "\n\n";          print_symbol('E'); return 0;}
    catch (exception& e)  {cerr << e.what() << endl << ret << "\n\n"; print_symbol('E'); return 0;}
  }
  print_symbol('X');
  return 0;
}
