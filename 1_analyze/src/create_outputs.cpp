#include "../../libs/bot.hpp"

// 4k screen is 398 x 92 @ size 14 font (7x5=35/396)

int main(int argc, char* argv[]) {
  if (argc != 2) {return 1;}

  string datum_name = argv[1], value;
  vector<string> label, mean, vmin, vmax, smin, smax, vstd, vvar, skew, kurt,
    arima1, arima2, arima3, sarimax1, sarimax2, sarimax3, dynamic1, dynamic2, expsmooth;
  bool short_list = false;
  try {
    value = get_first(raw_dir + datum_name);
    for (string window : windows) {
      label.push_back(window);
      mean.push_back( get_first(analysis_dir + datum_name +  "_" + window + "_mean") );
      vmin.push_back( get_first(analysis_dir + datum_name +  "_" + window + "_min") );
      vmax.push_back( get_first(analysis_dir + datum_name +  "_" + window + "_max") );
      smin.push_back( get_first(analysis_dir + datum_name +  "_" + window + "_smin") );
      smax.push_back( get_first(analysis_dir + datum_name +  "_" + window + "_smax") ); 
      vstd.push_back( get_first(analysis_dir + datum_name +  "_" + window + "_std") );
//      vvar.push_back( get_first(analysis_dir + datum_name +  "_" + window + "_var") );
//      skew.push_back( get_first(analysis_dir + datum_name +  "_" + window + "_skew") );
//      kurt.push_back( get_first(analysis_dir + datum_name +  "_" + window + "_kurt") );
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
  for (int i=0; i<windows.size(); ++i) printf(" %5smins ", windows[i].c_str() );
  printf("%-13s","|\n| mean:");
  for (int i=0; i<windows.size(); ++i) printf(" %9.9s ", mean[i].c_str() );
  printf("%-13s","|\n| min:");
  for (int i=0; i<windows.size(); ++i) printf(" %9.9s ", vmin[i].c_str() );
  printf("%-13s","|\n| max:");
  for (int i=0; i<windows.size(); ++i) printf(" %9.9s ", vmax[i].c_str() );
  printf("%-13s","|\n| smin:");
  for (int i=0; i<windows.size(); ++i) printf(" %9.9s ", smin[i].c_str() );
  printf("%-13s","|\n| smax:");
  for (int i=0; i<windows.size(); ++i) printf(" %9.9s ", smax[i].c_str() );
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
  return 0;
}


