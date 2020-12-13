// file: prepare_raw.cpp
#include "../../libs/bot.hpp"

float fee  = 0.0025;
float slip = 0.001;

int get_target(string &oldest_str, string &newest_str) {
  float oldest{stof(oldest_str)},
        newest{stof(newest_str)},
        delta{newest - oldest};
  int target;
  if      (delta > (newest *  (2.0*fee + 2.0*slip))) target =  5;              // up lots
  else if (delta < (newest * -(2.0*fee + 2.0*slip))) target =  1;              // down lots
  else if (delta > 0)                                target =  4;              // up a little
  else if (delta < 0)                                target =  2;              // down a little
  else                                               target =  3;              // zero movement
  return target;
}

int main(int argc, char* argv[]) {
  try {
    string filename{argv[1]},
           value{get_first(raw_dir + filename)};                              // read raw value
    for (string win_size : windows) {                                       // eg. {10,60,1440}
      string window_filename{windows_dir + filename + "_" + win_size + ".csv"},
             target_filename{targets_dir + filename + "_" + win_size};

      vector<string> window{get_all(window_filename)}, window_in{window};     // read window
      window.push_back(value); 

      int target = (window.size() > 0) ? get_target(window[0], window[window.size()-1]) : 0;
      if (window.size() > 2) write_trunc(target_filename, to_string(target)); // target file
      if (window.size() > stoi(win_size)) window.erase(window.begin());
      if (window_in != window) write_trunc(window_filename, window);          // window file
    }
  }
  catch (const char* s) {cerr << s << "\n\n";                print_symbol('E'); return 0;}
  catch (string s) {cerr << s << "\n\n";                     print_symbol('E'); return 0;}
  catch (exception& e)  {cerr << e.what() << endl << "\n\n"; print_symbol('E'); return 0;}

  return 0;
}

// predict_filename{labels_dir + filename + "_" + win_size + "_turing"};
//      if (window.size() > stoi(win_size)) {
//        float pred = update_pred(filename, win_size, value);
//      }
//
//
//int update_pred(string filename, string win_size) {
//  string pred_file     = predictions_dir + filename + "_" + win_size + "_turing.csv",
//         pred_win_file = pred + "_win";
//
//  vector<string> pred_window;
//  ifstream pred_win_file_test(pred_win_file); 
//  if (pred_win_file_test.good()) pred_window = get_all(pred_win_file);
//  
//  ifstream pred_file_test(pred_file);
//  if (pred_file_test.good()) pred_window.push_back(get_first(pred_file));
//  else pred_window.push_back("0");
//
//  float oldest_prediction = stof(pred_window[0]); 
//
//  if (pred_window.size() > stoi(win_size)) pred_window.erase(pred_window.begin());
//  write_trunc(pred_win_file, pred_window);
//
//  return oldest_prediction;
//}


