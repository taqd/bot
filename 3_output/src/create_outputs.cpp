#include "../../libs/bot.hpp"

string up =         "<span foreground=\"#00FF00\">⋀</span>",
         down     = "<span foreground=\"#FF0000\">⋁</span>",
         up_sig   = "<span foreground=\"#00FFFF\">⋀</span>",
         down_sig = "<span foreground=\"#FF00FF\">⋁</span>",
         stay = "<span foreground=\"gray\">•</span>",
         sep = "<span foreground='gray'>|</span>",
         end_span = "</span>",
         pair_color="<span foreground='green' weight='heavy'>";

class Datum {
  public:
  Datum() {}
  Datum(string code, string name, int win) { 
    window = win; 
    nice_name = name;
    paircode = code;
    load(paircode);
  }
  bool load(string paircode);
  bool save();
  bool print();
  string paircode, nice_name;
  int window, target, prediction;
  float bm, bl, sm, sl, av, bv, ask, bid, vol;
  vector<string> depth_ask, depth_bid; 
  int w03, w10, w60, w1440;
  int trd;
  float ohlc_vol;
  string a03, a10, a60;
  string a03acc, a10acc, a60acc, aacc;
  string d03, d10, d60;
  string d03acc, d10acc, d60acc, dacc;
};


bool Datum::load(string paircode) { 
 
  string win  = "10";
  ask = stof(get_first(raw_dir + paircode + "_tick_askprice"));
  bid = stof(get_first(raw_dir + paircode + "_tick_bidprice"));
  vol = stof(get_first(raw_dir + paircode + "_tick_24hvolume"));
  ohlc_vol = stof(get_first(raw_dir + paircode + "_ohlc_volprice"));
  trd = stof(get_first(raw_dir + paircode + "_ohlc_count"));

  bm  = stof(get_first(raw_dir + paircode + "_tradebmvolume_sum"));
  bl  = stof(get_first(raw_dir + paircode + "_tradeblvolume_sum"));
  sm  = stof(get_first(raw_dir + paircode + "_tradesmvolume_sum"));
  sl  = stof(get_first(raw_dir + paircode + "_tradeslvolume_sum"));
  av  = stof(get_first(raw_dir + paircode + "_depthaskvolum_sum"));
  bv  = stof(get_first(raw_dir + paircode + "_depthbidvolum_sum"));

  w03 = stof(get_first(targets_dir + paircode + "_tick_askprice_3"));
  w10 = stof(get_first(targets_dir + paircode + "_tick_askprice_10"));
  w60 = stof(get_first(targets_dir + paircode + "_tick_askprice_60"));
  w1440 = stof(get_first(targets_dir + paircode + "_tick_askprice_1440"));

  depth_ask.push_back(get_first(raw_dir + paircode + "_depthaskprice_count"));
  depth_bid.push_back(get_first(raw_dir + paircode + "_depthbidprice_count"));
  depth_ask.push_back(get_first(raw_dir + paircode + "_depthaskprice_stddev"));
  depth_bid.push_back(get_first(raw_dir + paircode + "_depthbidprice_stddev"));
  depth_ask.push_back(get_first(raw_dir + paircode + "_depthaskprice_skew"));
  depth_bid.push_back(get_first(raw_dir + paircode + "_depthbidprice_skew"));

  //int a03_t = stoi(get_first(forecast_dir + paircode +  "_tick_askprice_3.csv_arima201")); 
  //int a10_t = stoi(get_first(forecast_dir + paircode + "_tick_askprice_10.csv_arima201"));
  //int a60_t = stoi(get_first(forecast_dir + paircode + "_tick_askprice_60.csv_arima201"));
  //if (a03_t > 3) a03 = up;  if (a03_t == 3) a03 = stay;  if (a03_t < 3) a03 = down;
  //if (a10_t > 3) a10 = up;  if (a10_t == 3) a10 = stay;  if (a10_t < 3) a10 = down;
  //if (a60_t > 3) a60 = up;  if (a60_t == 3) a60 = stay;  if (a60_t < 3) a60 = down;
  //a03acc = get_first(utility_dir + paircode + "_tick_askprice_3.csv_arima201");
  //a10acc = get_first(utility_dir + paircode + "_tick_askprice_10.csv_arima201");
  //a60acc = get_first(utility_dir + paircode + "_tick_askprice_60.csv_arima201");
  //aacc = max({a03acc, a10acc, a60acc});

  //int d03_t = stoi(get_first(forecast_dir + paircode +  "_tick_askprice_3.csv_dynamicfmq21"));
  //int d10_t = stoi(get_first(forecast_dir + paircode + "_tick_askprice_10.csv_dynamicfmq21"));
  //int d60_t = stoi(get_first(forecast_dir + paircode + "_tick_askprice_60.csv_dynamicfmq21"));
  //if (d03_t > 3) d03 = up;  if (d03_t == 3) d03 = stay;  if (d03_t < 3) d03 = down;
  //if (d10_t > 3) d10 = up;  if (d10_t == 3) d10 = stay;  if (d10_t < 3) d10 = down;
  //if (d60_t > 3) d60 = up;  if (d60_t == 3) d60 = stay;  if (d60_t < 3) d60 = down;
  //d03acc = get_first(utility_dir + paircode + "_tick_askprice_3.csv_dynamicfmq21");
  //d10acc = get_first(utility_dir + paircode + "_tick_askprice_10.csv_dynamicfmq21");
  //d60acc = get_first(utility_dir + paircode + "_tick_askprice_60.csv_dynamicfmq21");
  //dacc = max({d03acc, d10acc, d60acc});
  return true; 
}

void print_pair(Datum d, int header = 0) {
  if      (header == 1) printf("| %-9.9s ", "");
  else if (header == 2) printf("| %-9.9s ", "");
  else if (header == 3) printf("| %-9.9s ", "pair");
  else printf("%s %s%-9.9s%s ", sep.c_str(), pair_color.c_str(), d.nice_name.c_str(), end_span.c_str());
}
void print_tick(Datum d, int header = 0) {
  if      (header == 1) printf("| %23.23s ", "");
  else if (header == 2) printf("| %23.23s ", "price");
  else if (header == 3) {
    printf("| %10.10s ", "ask");
    printf("| %10.10s ", "bid");
  } else {
    if (d.ask < .001) printf("%s %10.8f ", sep.c_str(), d.ask);
    else if (d.ask < 1) printf("%s %10.4f ", sep.c_str(), d.ask);
    else if (d.ask < 10) printf("%s %10.2f ", sep.c_str(), d.ask);
    else printf("%s %10.0f ", sep.c_str(), d.ask);
    if (d.bid < .001) printf("%s %10.8f ",sep.c_str(), d.bid);
    else if (d.bid < 1) printf("%s %10.4f ",sep.c_str(), d.bid);
    else if (d.bid < 10) printf("%s %10.2f ",sep.c_str(), d.bid);
    else printf("%s %10.0f ", sep.c_str(), d.bid);
  }
}
void print_numtrades(Datum d, int header = 0) {
  int trades = d.trd;
  if      (header == 1) printf("|%1.1s", "");
  else if (header == 2) printf("|%5.5s ", "num");
  else if (header == 3) printf("|%5.5s ", "trade");
  else {
    if (trades == 0) printf("%s%5.5s ", sep.c_str(), "");
    else if (trades < 10) printf("%s%5d ", sep.c_str(), trades);
    else printf("%s%5d ", sep.c_str(), trades);
  }
}

void print_avgvolume(Datum d, int header = 0) {
  float volume = d.vol / 1440;
  if      (header == 1) printf(" %7.7s ", "tick");
  else if (header == 2) printf("|%7.7s ", "avg vol");
  else if (header == 3) printf("|%7.7s ", "per min");
  else {
    if (volume == 0) printf("%s %6.6s ", sep.c_str(), "");
    else if (volume < 10) printf("%s %6.4f ", sep.c_str(), volume);
    else printf("%s %6.0f ", sep.c_str(), volume);
  }
}



void print_ohlcvolume(Datum d, int header = 0) {
  float volume = d.ohlc_vol;
  if      (header == 1) printf("%13.13s ", "last min ohlc");
  else if (header == 2) printf("| %6.6s ", "total");
  else if (header == 3) printf("| %6.6s ", "volume");
  else {
    if (volume == 0) printf("%s %6.6s ", sep.c_str(), "");
    else if (volume < 10) printf("%s %6.2f ", sep.c_str(), volume);
    else printf("%s %6.0f ", sep.c_str(), volume);
  }
}


void print_market(Datum d, int header = 0) {
  if      (header == 1) printf("| %21.21s ", "");
  else if (header == 2) printf("| %21.21s ", "market volume");
  else if (header == 3) {
    printf("| %9.9s ", "buy");
    printf("| %9.9s ", "sell");
  } else {
    if (d.bm == 0) printf("%s %9s ", sep.c_str(), "");
    else if (d.bm > 10) printf("%s %9.0f ", sep.c_str(), d.bm);
    else printf("%s %9.2f ",sep.c_str(), d.bm);
    if (d.sm == 0) printf("%s %9s ", sep.c_str(), "");
    else if (d.sm > 10) printf("%s %9.0f ", sep.c_str(), d.sm);
    else printf("%s %9.2f ", sep.c_str(), d.sm);
  }
}

void print_limit(Datum d, int header = 0) {
  if      (header == 1) printf("  %21.21s ", "trades");
  else if (header == 2) printf("| %21.21s ", "limit volume");
  else if (header == 3) {
    printf("| %9.9s ", "buy");
    printf("| %9.9s ", "sell");
  } else {
    if (d.bl == 0) printf("%s %9s ", sep.c_str(), "");
    else if (d.bl > 10) printf("%s %9.0f ", sep.c_str(), d.bl);
    else printf("%s %9.2f ", sep.c_str(), d.bl);
    if (d.bl == 0) printf("%s %9s ",sep.c_str(), "");
    else if (d.sl > 10) printf("%s %9.0f ", sep.c_str(), d.sl);
    else printf("%s %9.2f ", sep.c_str(), d.sl);
  }
}
void print_depthask(Datum d, int header = 0) {
  if      (header == 1) printf("| %31.31s ", "");
  else if (header == 2) printf("| %31.31s ", "ask");
  else if (header == 3)   
    printf("| %9.9s | %4.4s | %5.5s | %4.4s ", "sum vol", "num", "std", "skew");
  else {  
    if (d.av > 1000000) printf("%s %9.0f ", sep.c_str(), d.av);
    else if (d.av < 1) printf("%s %9.4f ", sep.c_str(), d.av);
    else if (d.av < 10) printf("%s %9.2f ", sep.c_str(), d.av);
    else printf("%s %9.0f ", sep.c_str(), d.av);
  
    printf("%s %4.4s ", sep.c_str(), d.depth_ask[0].c_str());
    printf("%s %5.5s ", sep.c_str(), d.depth_ask[1].c_str());
    printf("%s %4.4s ", sep.c_str(), d.depth_ask[2].c_str());
  }  
}  
void print_depthbid(Datum d, int header = 0) {
  if      (header == 1) printf("  %31.31s ", "order book");
  else if (header == 2) printf("| %31.31s ", "bids");
  else if (header == 3) printf("| %9.9s | %4.4s | %5.5s | %5.5s", "sum", "num", "std", "skew");
  else {
    if (d.av > 1000000) printf("%s %9.0f ", sep.c_str(), d.av);
    else if (d.av < 1) printf("%s %9.4f ", sep.c_str(), d.av);
    else if (d.av < 10) printf("%s %9.2f ", sep.c_str(), d.av);
    else printf("%s %9.0f ", sep.c_str(), d.av);

    printf("%s %4.4s ", sep.c_str(), d.depth_bid[0].c_str());
    printf("%s %5.5s ", sep.c_str(), d.depth_bid[1].c_str());
    printf("%s %4.4s ", sep.c_str(), d.depth_bid[2].c_str());
  }
}

void print_delta(Datum d, int header = 0) {
  float volume = d.vol / 1440;
  string win3,win10,win60;

  if (d.w03 == 5) win3 = up_sig;
  if (d.w03 == 4) win3 = up;
  if (d.w03 == 3) win3 = stay;
  if (d.w03 == 2) win3 = down;
  if (d.w03 == 1) win3 = down_sig;
  if (d.w10 == 5) win10 = up_sig;
  if (d.w10 == 4) win10 = up;
  if (d.w10 == 3) win10 = stay;
  if (d.w10 == 2) win10 = down;
  if (d.w10 == 1) win10 = down_sig;
  if (d.w60 == 5) win60 = up_sig;
  if (d.w60 == 4) win60 = up;
  if (d.w60 == 3) win60 = stay;
  if (d.w60 == 2) win60 = down;
  if (d.w60 == 1) win60 = down_sig;


  if      (header == 1) printf("  %5.5s ", "" );
  else if (header == 2) printf("|%7.7s", " delta ");
  else if (header == 3) printf("|%2.2s %2.2s %1.1s", "60", "10", "3");
  else printf("%s %s %s %s ", sep.c_str(), win60.c_str(), win10.c_str(), win3.c_str());
}



void print_babbage(Datum d, int header = 0) {

  if      (header == 1) printf("| ");
  else if (header == 2) {
    printf("|  %17.17s ", "babbage ai (v0.1)");
  } else if (header == 3) {
    printf("| %4.4s ", "pred");
    printf("| %4.4s ", "call");
    printf("| %4.4s ", "roi");
  } else {
    printf("%s  %s%s%s ", sep.c_str(), d.a03.c_str(), d.a10.c_str(), d.a60.c_str()); 
    printf("%s %4.4s ", sep.c_str(), "stay"); 
    printf("%s %3.3s%% ", sep.c_str(), d.a10acc.c_str()); 
  }
}
void print_lovelace(Datum d, int header = 0) {

  if      (header == 1) printf(" %38.38s ", "predictions of future");
  else if (header == 2) {
    printf("|  %17.17s ", "lovelace ai (v0.1)");
  } else if (header == 3) {
    printf("| %4.4s ", "pred");
    printf("| %4.4s ", "call");
    printf("| %4.4s ", "roi");
  } else {
    printf("%s  %s%s%s ", sep.c_str(), d.d03.c_str(), d.d10.c_str(), d.d60.c_str()); 
    printf("%s %4.4s ", sep.c_str(), "buy"); 
    printf("%s %3.3s%% ", sep.c_str(), d.d10acc.c_str()); 
  }
}

int main(int argc, char* argv[]) {
  if (argc != 4) {return 1;}
  string paircode = argv[1], nice_name = argv[2], header_on = argv[3];

  Datum d(paircode, nice_name, 10);
  if (header_on == "on") {
    cout << "<span foreground='grey'>";
    for (int i = 1 ; i <= 3; ++i) {
      print_pair(d,i);
      print_tick(d,i);
      print_delta(d,i);
      print_avgvolume(d,i);
      print_numtrades(d,i);
      print_ohlcvolume(d,i);
      print_market(d,i);
      print_limit(d,i);
      print_depthask(d,i);
      print_depthbid(d,i);
      // print_babbage(d,i);
      //  print_lovelace(d,i);
      cout << "|\n";
    }
    cout << "</span>";
  }
  print_pair(d);
  print_tick(d);
  print_delta(d);
  print_avgvolume(d);
  print_numtrades(d);
  print_ohlcvolume(d);
  print_market(d);
  print_limit(d);
  print_depthask(d);
  print_depthbid(d);
  //  print_babbage(d);
  //  print_lovelace(d);

  cout << "<span foreground='grey'>";
  cout << "|\n";
  cout << "</span>";
  return 0;
}
// cout.sync_with_stdio(false);
//   cout.imbue(locale("en_US.utf8"));
/*
 *  if (header_on == "on") {
 printf("\n| %-8.8s | %25.25s | %81.81s |\n",\
 "kraken","","cumulative volume in the last minute");
 printf("| %-8.8s | %25.25s | %25.25s | %25.25s | %25.25s |\n",\
 "","tick price","market","limit","order book");
 printf("| %-8.8s | %11.11s | %11.11s | %11.11s | %11.11s | %11.11s | %11.11s | %11.11s | %11.11s |\n",\
 "pair",
 "ask", "bid",\
 "buy", "sell", "buy", "sell",\
 "asks", "bids");
 }

 *  printf("| %-8.8s | %11.2f | %11.2f | %11.2f | %11.2f | %11.2f | %11.2f | %11.0f | %11.0f | ",\
 nice_name.c_str(),\
 d.ask, d.bid,\
 d.bm, d.sm, d.bl, d.sl,\
 d.bv, d.av);

 *  aavg = stof(get_first(analysis_dir + paircode + "_tick_askprice_" + win + "_mean"));
 amin = stof(get_first(analysis_dir + paircode + "_tick_askprice_" + win + "_min"));
 amax = stof(get_first(analysis_dir + paircode + "_tick_askprice_" + win + "_max"));
 astd = stof(get_first(analysis_dir + paircode + "_tick_askprice_" + win + "_stddev"));
 askew = stof(get_first(analysis_dir + paircode + "_tick_askprice_" + win + "_skew"));
 akurt = stof(get_first(analysis_dir + paircode + "_tick_askprice_" + win + "_kurt"));
 bavg = stof(get_first(analysis_dir + paircode + "_tick_bidprice_" + win + "_mean"));
 bmin = stof(get_first(analysis_dir + paircode + "_tick_bidprice_" + win + "_min"));
 bmax = stof(get_first(analysis_dir + paircode + "_tick_bidprice_" + win + "_max"));
 bstd = stof(get_first(analysis_dir + paircode + "_tick_bidprice_" + win + "_stddev"));
 bskew = stof(get_first(analysis_dir + paircode + "_tick_bidprice_" + win + "_skew"));
 bkurt = stof(get_first(analysis_dir + paircode + "_tick_bidprice_" + win + "_kurt"));
 cbm   = stof(get_first(raw_dir + paircode + "_tradebmvolume_count"));
 cbl   = stof(get_first(raw_dir + paircode + "_tradeblvolume_count"));
 csm   = stof(get_first(raw_dir + paircode + "_tradesmvolume_count"));
 csl   = stof(get_first(raw_dir + paircode + "_tradeslvolume_count"));
 cav   = stof(get_first(raw_dir + paircode + "_depthaskvolum_count"));
 cbv   = stof(get_first(raw_dir + paircode + "_depthbidvolum_count"));

 int cbm, cbl, csm, csl, cav, cbv;
 float amin, amax, aavg, astd, adelta, askew, akurt;
 float bmin, bmax, bavg, bstd, bdelta, bskew, bkurt;




 *  cout.sync_with_stdio(false);
 cout.imbue(locale("en_US.utf8"));
 printf("%8s | ", paircode.c_str());

 print_line("ask p: ", d.ask, false);
 print_line("bid p: ", d.bid, true);

 print_line("buy  m: ", d.bm, false);
 print_line("sell m: ", d.sm, true);

 print_line("buy  l: ", d.bl, false);
 print_line("sell l: ", d.sl, true);

 print_line("bid v: ", d.bv, false);
 print_line("ask v: ", d.av, true);
 void print_line(string name, float value, bool header) {
 if (header) printf("%-8.8s | ", name.c_str());
 else        printf("%8.2f", value);
 }


 bool Datum::print() { 
 cout << "Pair: " << datum_name << endl;
 cout << "Ask: " << ask << "\t"; cout << " | Bid: " << bid << " " << endl;
 cout << "Min: "  << amin << "\t";  cout<< " | Min: " << bmin << endl;
 cout << "Max: "  << amax << "\t";  cout<< " | Max: " << bmax << endl;
cout << "Avg: "  << aavg << "\t";  cout<< " | Avg: " << bavg << endl;
cout << "Std: "  << astd << "\t";  cout<< " | Std: " << bstd << endl;
cout << "Skew: " << askew << "\t"; cout<< " | Skew: " << bskew << endl;
cout << "Kurt: " << akurt << "\t"; cout<< " | Kurt: " << bkurt << endl;
cout << "\nVolume:\n";
cout << "Buy M: " << bm << "\t"; cout << " | SellM: " << sm << endl; 
cout << "Buy L: " << bl << "\t"; cout << " | SellL: " << sl << endl; 
cout << "Bid V: " << bv << "\t"; cout << " | Ask V: " << av << endl; 

return true;
}


vector<string> label, mean, vmin, vmax, ttmin, ttmax, vstd, vvar, skew, kurt,
  arima1, arima2, arima3, sarimax1, sarimax2, sarimax3, dynamic1, dynamic2, expsmooth;
bool short_list = false;
try {
  value = get_first(raw_dir + datum_name);
  for (string window : windows) {
    label.push_back(window);
    mean.push_back( get_first(analysis_dir + datum_name +  "_" + window + "_mean") );
    vmin.push_back( get_first(analysis_dir + datum_name +  "_" + window + "_min") );
    vmax.push_back( get_first(analysis_dir + datum_name +  "_" + window + "_max") );
    ttmin.push_back( get_first(analysis_dir + datum_name +  "_" + window + "_ttmin") );
    ttmax.push_back( get_first(analysis_dir + datum_name +  "_" + window + "_ttmax") ); 
    vstd.push_back( get_first(analysis_dir + datum_name +  "_" + window + "_stddev") );
    //      vvar.push_back( get_first(analysis_dir + datum_name +  "_" + window + "_var") );
    skew.push_back( get_first(analysis_dir + datum_name +  "_" + window + "_skew") );
    kurt.push_back( get_first(analysis_dir + datum_name +  "_" + window + "_kurt") );
    ifstream exists(forecast_dir + datum_name + "_" + window + "_arima012");
    if (!exists.good()) { short_list = true; continue; }
    arima1.push_back( get_first(forecast_dir + datum_name + "_" + window + "_arima012") );
    arima2.push_back( get_first(forecast_dir + datum_name + "_" + window + "_arima201") );
    arima3.push_back( get_first(forecast_dir + datum_name + "_" + window + "_arima120") );
    dynamic1.push_back( get_first(forecast_dir + datum_name + "_" + window + "_dynamicfmq12") );
    dynamic2.push_back( get_first(forecast_dir + datum_name + "_" + window + "_dynamicfmq21") );
    expsmooth.push_back( get_first(forecast_dir + datum_name + "_" + window + "_expsmooth") );
    sarimax1.push_back( get_first(forecast_dir + datum_name + "_" + window + "_sarimax012c") );
    sarimax2.push_back( get_first(forecast_dir + datum_name + "_" + window + "_sarimax201c") );
    sarimax3.push_back( get_first(forecast_dir + datum_name + "_" + window + "_sarimax120c") );
  }
} catch (const char* s) {
  cerr << "print_stat failed " << datum_name << "\t" << s << endl; print_symbol('E'); return 0;
} catch (string s) {
  cerr << "print_stat failed " << datum_name << "\t" << s << endl; print_symbol('E'); return 0;
} catch (exception& e) {
  cerr << "print_stat failed " << datum_name <<"\t"<<e.what()<< endl; print_symbol('E'); return 0;
}



for (int i=0; i<78; ++i) printf("-");
printf("\n| name: "); printf("%68s ", datum_name.c_str());
printf("|\n| latest value: "); printf("%60s ", value.c_str());
printf("%-13s","|\n| window:");
for (int i=0; i<windows.size(); ++i) printf(" %5s mins ", windows[i].c_str() );
printf("%-13s","|\n| mean:");
for (int i=0; i<windows.size(); ++i) printf(" %9.9s ", mean[i].c_str() );
printf("%-13s","|\n| min:");
for (int i=0; i<windows.size(); ++i) printf(" %9.9s ", vmin[i].c_str() );
printf("%-13s","|\n| max:");
for (int i=0; i<windows.size(); ++i) printf(" %9.9s ", vmax[i].c_str() );
printf("%-13s","|\n| ttmin:");
for (int i=0; i<windows.size(); ++i) printf(" %9.9s ", ttmin[i].c_str() );
printf("%-13s","|\n| ttmax:");
for (int i=0; i<windows.size(); ++i) printf(" %9.9s ", ttmax[i].c_str() );
printf("%-13s","|\n| std:");
for (int i=0; i<windows.size(); ++i) printf(" %9.9s ", vstd[i].c_str() );
if (!short_list) {
  printf("%-13s","|\n| arima012:");
  for (int i=0; i<windows.size(); ++i) printf(" %9.9s ", arima1[i].c_str() );
  printf("%-13s","|\n| arima201:");
  for (int i=0; i<windows.size(); ++i) printf(" %9.9s ", arima2[i].c_str() );
  printf("%-13s","|\n| arima120:");
  for (int i=0; i<windows.size(); ++i) printf(" %9.9s ", arima3[i].c_str() );

  printf("%-13s","|\n| dynamic1:");
  for (int i=0; i<windows.size(); ++i) printf(" %9.9s ", dynamic1[i].c_str() );
  printf("%-13s","|\n| dynamic2:");
  for (int i=0; i<windows.size(); ++i) printf(" %9.9s ", dynamic2[i].c_str() );

  printf("%-13s","|\n| smooth:");
  for (int i=0; i<windows.size(); ++i) printf(" %9.9s ", expsmooth[i].c_str() );
  printf("%-13s","|\n| sarimax1:");
  for (int i=0; i<windows.size(); ++i) printf(" %9.9s ", sarimax1[i].c_str() );
  printf("%-13s","|\n| sarimax2:");
  for (int i=0; i<windows.size(); ++i) printf(" %9.9s ", sarimax2[i].c_str() );
  printf("%-13s","|\n| sarimax3:");
  for (int i=0; i<windows.size(); ++i) printf(" %9.9s ", sarimax3[i].c_str() );
}
cout << "|" << endl;
for (int i=0; i<78; ++i) printf("-");
cout << endl;
*/

