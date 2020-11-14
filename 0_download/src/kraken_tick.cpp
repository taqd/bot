// file: kraken_tick.cpp
#include "../../libs/bot.hpp"

int main(int argc, char *argv[]) {
  string paircodes{argv[1]}; for (int i = 1; i < argc; ++i) paircodes += "," + string{argv[i]};
  string page{"https://api.kraken.com/0/public/Ticker"},  
         page_opt{"pair=" + paircodes}, ret{""};
  try {
    CURL* c = curl_easy_init(); if (!c) throw "bad curl init";
    if (!download_data(c, page, page_opt, ret)) throw "bad data download";
    curl_easy_cleanup(c);
    json j{json::parse(ret)};
    if (!j["error"].empty()) throw "error data: " + j["error"].get<string>();
    for (auto& [paircode, value] : j["result"].items()){
      string f = raw_dir + paircode + "_tick_";
      float askprice =  stof(value["a"][0].get<string>());
      float askwhovol = stof(value["a"][1].get<string>());
      float askvolume = stof(value["a"][2].get<string>());
      float bidprice =  stof(value["b"][0].get<string>());
      float bidwhovol = stof(value["b"][1].get<string>());
      float bidvolume = stof(value["b"][2].get<string>());
      float lastprice = stof(value["c"][0].get<string>());
      float lastvolum = stof(value["c"][1].get<string>());
      float dayvolume = stof(value["v"][0].get<string>());
      float volume24h = stof(value["v"][1].get<string>());
      float avgdayprc = stof(value["p"][0].get<string>());
      float avg24hprc = stof(value["p"][1].get<string>());
      int numtrdday = value["t"][0].get<int>();
      int numtrd24h = value["t"][1].get<int>();
      float lowday =    stof(value["l"][0].get<string>());
      float low24h =    stof(value["l"][1].get<string>());
      float highday =   stof(value["h"][0].get<string>());
      float high24h =   stof(value["h"][1].get<string>());
      float openday =   stof(value["o"].get<string>());
      check_and_save(f + "askprice",  askprice);
      check_and_save(f + "askwhovol", askwhovol);
      check_and_save(f + "askvolume", askvolume);
      check_and_save(f + "bidprice",  bidprice);
      check_and_save(f + "bidwhovol", bidwhovol);
      check_and_save(f + "bidvolume", bidvolume);
      check_and_save(f + "lastprice", lastprice);
      check_and_save(f + "lastvolum", lastvolum);
      check_and_save(f + "dayvolume", dayvolume);
      check_and_save(f + "24hvolume", volume24h);
      check_and_save(f + "avgdayprc", avgdayprc);
      check_and_save(f + "avg24hprc", avg24hprc);
      check_and_save(f + "numtrdday", numtrdday);
      check_and_save(f + "numtrd24h", numtrd24h);
      check_and_save(f + "lowday",    lowday);
      check_and_save(f + "low24h",    low24h);
      check_and_save(f + "highday",   highday);
      check_and_save(f + "high24h",   high24h);
      check_and_save(f + "openday",   openday);

      if (DB>0)
        cout << paircode << fixed << setprecision(2)
          << "   \task: " << askprice  << "/" << askwhovol << "/" << askvolume
          << "\t   bid: " << bidprice  << "/" << bidwhovol << "/" << bidvolume
          << "\tlast: "   << lastprice << "/" << lastvolum
          << "\ta_vol: "  << dayvolume << "/" << volume24h
          << "\t a_pri: " << avgdayprc << "/" << avg24hprc
          << "\tn_trd: "  << numtrdday << "/" << numtrd24h
          << "\tlow: "    << lowday    << "/" << low24h
          << "\thigh: "   << highday   << "/" << high24h
          << "\topen: "   << openday   << endl;
    }
  } 
  catch (const char* s) {cerr << ret << "\n\n";                     print_symbol('E'); return 0;}
  catch (string s) {cerr << s << " ::: " << ret << "\n\n";          print_symbol('E'); return 0;}
  catch (exception& e)  {cerr << e.what() << endl << ret << "\n\n"; print_symbol('E'); return 0;}

  print_symbol('T');
  return 0;
}
