// file: prepare_raw.cpp
#include "../../libs/bot.hpp"

float fee = 0.0025;
float slip = 0.001;

void print_targets(vector<int> targets) {
  cout << " targets: ";
  for (int target : targets) {
    if (target ==  2) print_symbol("2");
    if (target ==  1) print_symbol("1");
    if (target ==  0) print_symbol("0");
    if (target == -1) print_symbol("-1");
    if (target == -2) print_symbol("-2");
  }
  cout << ") ";
}

int get_target(string &oldest_str, string &newest_str) {
  float oldest{stof(oldest_str)},
        newest{stof(newest_str)},
        delta{newest - oldest};
  int target;
  if      (delta > (newest *  (2.0*fee + 2.0*slip))) target =  2;       // up lots
  else if (delta < (newest * -(2.0*fee + 2.0*slip))) target = -2;       // down lots
  else if (delta > 0)                                target =  1;       // up a little
  else if (delta < 0)                                target = -1;       // down a little
  else                                               target =  0;       // zero movement
  return target;
}

int main(int argc, char* argv[]) {
  try {
    string filename{argv[1]},
           value{get_first(raw_dir + filename)};                          // read raw value
    vector<int> tmp_targets;
    for (int w : windows) {                                       // eg. {10,60,1440,10080}
      string win_size{to_string(w)},
             window_filename{windows_dir + filename + "_" + win_size},
             target_filename{targets_dir + filename + "_" + win_size};
      vector<string> window{get_all(window_filename)}, window_in{window}; // read window
      window.push_back(value); 
      int target = (window.size() > 0) ? get_target(window[0], window[window.size()-1]) : 0;
      if (window.size() > 3) write_trunc(target_filename, to_string(target)); // target file
      if (window.size() > stoi(win_size)) window.erase(window.begin());   
      if (window_in != window) write_trunc(window_filename, window);      // window file
      if (filename == target_name) tmp_targets.push_back(target);
    }
    if (filename == target_name) {
      cout << fixed << setprecision(1) << "(btcusd: " << stof(value);
      print_targets(tmp_targets);
    }
  }
  catch (const char* s) {cerr << s << "\n\n";                print_symbol('E');}
  catch (string s) {cerr << s << "\n\n";                     print_symbol('E');}
  catch (exception& e)  {cerr << e.what() << endl << "\n\n"; print_symbol('E');}

  return 0;
}
