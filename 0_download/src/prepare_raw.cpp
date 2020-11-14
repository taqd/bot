// file: prepare_raw.cpp
#include "../../libs/bot.hpp"

float fee = 0.0025;
float slip = 0.001;

void print_targets(vector<int> targets) {
  for(vector<int>::reverse_iterator it = targets.rbegin(); it != targets.rend(); ++it) {
    int target = *it;
    if (target ==  2) print_symbol("2");
    if (target ==  1) print_symbol("1");
    if (target ==  0) print_symbol("0");
    if (target == -1) print_symbol("-1");
    if (target == -2) print_symbol("-2");
  }
  cout << " ";
}

void print_predictions(vector<int> predictions) {
  cout << " ";
  for (int prediction : predictions) {
    if (prediction ==  2) print_symbol("2");
    if (prediction ==  1) print_symbol("1");
    if (prediction ==  0) print_symbol("0");
    if (prediction == -1) print_symbol("-1");
    if (prediction == -2) print_symbol("-2");
  }
  cout << " ";
}


int get_target(string &oldest_str, string &newest_str) {
  float oldest{stof(oldest_str)},
        newest{stof(newest_str)},
        delta{newest - oldest};
  int target;
  if      (delta > (newest *  (2.0*fee + 2.0*slip))) target =  2;              // up lots
  else if (delta < (newest * -(2.0*fee + 2.0*slip))) target = -2;              // down lots
  else if (delta > 0)                                target =  1;              // up a little
  else if (delta < 0)                                target = -1;              // down a little
  else                                               target =  0;              // zero movement
  return target;
}

vector<string> get_models(string filename, string win_size) {
  vector<string> models;
  models.push_back(predictions_dir + "/../" + filename + "_perc1.csv"); 
  return models;
}

int update_util(string model_name, string win_size, string newest_measurement) {
  string model_pred_file     = model_name,
         model_pred_win_file = model_name + "_win",
         model_util_file     = model_name + "_util";
  ifstream exist_test(model_pred_file); if (!exist_test.good()) return 0;
  ifstream exist_test2(model_pred_win_file); 
  vector<string> pred_window;
  if (exist_test2.good()) pred_window = get_all(model_pred_win_file);
  if (exist_test.good()) pred_window.push_back(get_first(model_pred_file));
  else pred_window.push_back(0);

  float prediction = stof(pred_window[0]), 
        measurement = stof(newest_measurement);
  int util=0;
  if      (prediction >  0 && measurement >  0) util = 1; 
  else if (prediction <  0 && measurement <  0) util = 1; 
  else if (prediction == 0 && measurement == 0) util = 1; 
  else                                          util = 0; 

  if (pred_window.size() > stoi(win_size)) pred_window.erase(pred_window.begin());
  write_trunc(model_pred_win_file, pred_window);

  ifstream exist_test3(model_util_file); 
  util = exist_test3.good() ? stoi(get_first(model_util_file)) + util : util;
  write_trunc(model_util_file, to_string(util));

  return stoi(pred_window[pred_window.size() -1]);
}


int main(int argc, char* argv[]) {
  try {
    string filename{argv[1]},
           value{get_first(raw_dir + filename)};                              // read raw value
    vector<int> tmp_targets, tmp_preds;
    for (string win_size : windows) {                                         // eg. {3,10,60,1440}
      string window_filename{windows_dir + filename + "_" + win_size},
             target_filename{targets_dir + filename + "_" + win_size};

      vector<string> window{get_all(window_filename)}, window_in{window};     // read window
      window.push_back(value); 

      int target = (window.size() > 0) ? get_target(window[0], window[window.size()-1]) : 0;
      if (window.size() > 3) write_trunc(target_filename, to_string(target)); // target file

      if (window.size() > stoi(win_size)) {
        string perc1_model = predictions_dir + filename + "_" + win_size + "_perc1.csv";
        int pred = update_util(perc1_model, win_size, value);
        if (filename == target_name) tmp_preds.push_back(pred);
        window.erase(window.begin());   
      }

      if (window_in != window) write_trunc(window_filename, window);          // window file
      if (filename == target_name) tmp_targets.push_back(target);
    }
    if (filename == target_name) {
      print_targets(tmp_targets);
      cout << fixed << setprecision(2) << "btcusd:" << stof(value) ;
      print_predictions(tmp_preds);
    }
  }
  catch (const char* s) {cerr << s << "\n\n";                print_symbol('E'); return 0;}

  catch (string s) {cerr << s << "\n\n";                     print_symbol('E'); return 0;}
  catch (exception& e)  {cerr << e.what() << endl << "\n\n"; print_symbol('E'); return 0;}

  return 0;
}
