#include <algorithm>
#include <chrono>
#include <thread>
#include <locale>
#include <filesystem>
#include <fstream>
#include <iostream>
#include <iomanip>
#include <cstdlib>
#include <cmath>
#include <numeric>
#include <random>
#include <stdexcept>
#include <string>
#include <sstream>
#include <vector>
#include <curl/curl.h>
#include <map>
#include "json.hpp"
using namespace std;
using json = nlohmann::json;


int DB = 0;
/**************************GLOBALS*********************************************/

vector<string> windows{"3", "10", "60"};

string root_dir         = "../",
       data_dir         = root_dir + "data/",
       raw_dir          = data_dir + "raw/",
       vector_dir         = data_dir + "vectors/",
       windows_dir      = data_dir + "windows/",
       analysis_dir     = data_dir + "analysis/",
       forecast_dir     = data_dir + "forecast/",
       models_dir       = data_dir + "models/",
       state_dir        = data_dir + "state/",
       predictions_dir  = data_dir + "predictions/",
       targets_dir      = data_dir + "targets/",
       utility_dir      = data_dir + "utility/",
       target_name      = "XXBTZUSD_tick_askprice",
       ask_filename     = raw_dir + target_name,
       usd_filename     = state_dir + "avail_usd",
       btc_filename     = state_dir + "avail_btc",
       bal_filename     = state_dir + "balance.value",
       bal_del_filename = state_dir + "balance.delta";

/**************************ERROR HANDLING**************************************/
void print_symbol(char c) {
  if (c=='E') cout << "X" << flush; // cout << "\033[;41m\u2716\033[0m";
  else cout << "*" << flush;
  return;
  if (c=='T') cout << "\033[;31m\u2713\033[0m"; // red
  if (c=='O') cout << "\033[;32m\u2713\033[0m"; // green
  if (c=='D') cout << "\033[;33m\u2713\033[0m"; // orange
  if (c=='S') cout << "\033[;34m\u2713\033[0m"; // blue
  if (c=='X') cout << "\033[;35m\u2713\033[0m"; // pink
  if (c=='U') cout << "\033[;36m\u2713\033[0m";
  if (c=='M') cout << "\033[;37m\u2713\033[0m"; // white

  if (c=='0') cout << "\033[;35m-\033[0m";
  if (c=='1') cout << "\033[;32m\u2191\033[0m";
  if (c=='2') cout << "\033[;31m\u2193\033[0m";
  cout << flush;
}

void print_symbol(string c) {
  if (c=="2")  cout << "\033[;42m\u2191\033[0m";
  if (c=="1")  cout << "\033[;32m\u2191\033[0m";
  if (c=="0")  cout << "\033[;37m-\033[0m";
  if (c=="-1") cout << "\033[;31m\u2193\033[0m";
  if (c=="-2") cout << "\033[;41m\u2193\033[0m";
  cout << flush;
}

void print_error(string f, int i, vector<string> d, string error) {
  cerr << "\n\n--- throw --- : " << error << " exception in " << f << " | ";
  if (i > 0 && i < d.size() - 1) {
    for (int j = 0; j < i; ++j) cerr << j << " = " <<  d[j] << endl;
    cerr << i << " =  ***[" << d[i] << "]*** " << endl;
    for (int j = i+1; j < d.size(); ++j) cerr << j << " = " <<  d[j] << endl;
  } else {
    int z = 0;
    for (string s : d) {cerr << z << " = " << s << "\n"; z++;}
  }
  print_symbol('E');
}

/**************************FILE INTERACTION************************************/
string get_first(string file) {
  string ret; 
  ifstream in{file}; if (!in) throw "bad get first, likely no file: " + file;
  in >> ret;
  return ret;
}
vector<string> get_all(string file) {
  vector<string> ret; string tmp;
  ifstream in{file}; if (!in) return ret;
  while (in >> tmp) ret.push_back(tmp);
  return ret;
}
vector<string> get_last(string file, int n) {
  vector<string> ret; string tmp;
  ifstream in{file, ios_base::ate}; if (!in) throw "bad_get_lastN: " + file;
  for(int i=in.tellg(), nn=n; i>0 && nn>=0; --i) {
    in.seekg(-1, ios_base::cur); if (in.peek() == '\n') nn--;
  }
  while (in >> tmp) ret.push_back(tmp); return ret;
}
string get_last(string file) {
  vector<string> lasts = get_last(file,1);
  if (lasts.size() == 0) throw "no last in " + file ;
  return lasts[0];
}

void write_append(string file, string value) {
  ofstream out{file, ios_base::app}; if (!out) throw "bad append with" + file;
  out << value << '\n' << flush;
}

void write_trunc(string file, string value) {
  ofstream out{file, ios_base::trunc}; if (!out) throw "bad trunc with" + file;
  out << " " << value << flush;
}
void write_trunc(string file, vector<string>& values) {
  ofstream out{file, ios_base::trunc}; if (!out) throw "bad trunc with" + file;
  for (string value : values)  out << value << endl;
}
void write_trunc(string file, vector<int>& values) {
  ofstream out{file, ios_base::trunc}; if (!out) throw "bad trunc with" + file;
  for (int value : values)  out << value << endl;
}
void write_trunc(string file, vector<float>& values) {
  ofstream out{file, ios_base::trunc}; if (!out) throw "bad trunc with" + file;
  for (float value : values)  out << value << endl;
}



/**************************STRING MANIPULATION*********************************/
vector<string> tokenize(string &s) {
  for(char& c : s) if( !isalnum(c) && c != '.')  c = ' ';
  vector<string> x; stringstream ss{s};
  for(string st; ss>>st;) x.push_back(st);
  return x;
}
string since_read(string who) {
  ifstream f(state_dir + who + "_since");
  if (f.good()) return get_first(state_dir + who + "_since");
  return "0";
}
void since_write(string who, string s) {
  write_trunc(state_dir + who + "_since", s);
}

/**************************CURL***********************************************/
static size_t curl_response(char* ptr,size_t size,size_t nmemb,void* resp) {
  string* response = reinterpret_cast<string*>(resp);
  response->append(ptr, size * nmemb); return size * nmemb;
}
bool download_data(CURL* c, string& page, string& opt, string &ret) {
  curl_easy_setopt(c, CURLOPT_POST, 1L);
  curl_easy_setopt(c, CURLOPT_URL, page.c_str());                 // set api url
  curl_easy_setopt(c, CURLOPT_POSTFIELDS, opt.c_str());           // set options
  curl_easy_setopt(c, CURLOPT_HTTPHEADER, NULL);                  // unknown
  curl_easy_setopt(c, CURLOPT_WRITEFUNCTION, curl_response);      // callbackfun
  curl_easy_setopt(c, CURLOPT_WRITEDATA,static_cast<void*>(&ret));// data return
  if (curl_easy_perform(c) != CURLE_OK) return false; return true;// do net call
}

/**************************DATA MANAGEMENT*************************************/
void check_and_save(string f, float value){
  float low{0}, hi{100000000};                              //min val, max val
  if (low > value || hi < value) 
    throw "out-of-range:"+to_string(low)+"<"+to_string(value)+"<"+to_string(hi);
  ostringstream value_str;
  value_str << value;
//value_str << fixed << setprecision(2) << value;
  string ret = value_str.str();
  write_trunc(f,ret);
}
void check_and_save(string f, string v){ check_and_save(f, stof(v)); }
void check_and_save(string f, int v){ check_and_save(f, static_cast<float>(v));}
void check_and_save(string f, vector<string> v) { write_trunc(f,v);}
void check_and_save(string f, vector<int> v) { write_trunc(f,v);}
void check_and_save(string f, vector<float> v) { write_trunc(f,v);}



