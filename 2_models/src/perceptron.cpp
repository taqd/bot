// file: perceptron.cpp
#include "../../libs/bot.hpp"
int main(int argc, char* argv[]) {
  try {
    int seed = (argc > 1) ? stoi(argv[1]) : 42;
    cout << "seed: " << seed << endl;
  }
  catch (const char* s) {cerr << s << "\n\n";                print_symbol('E');}
  catch (string s) {cerr << s << "\n\n";                     print_symbol('E');}
  catch (exception& e)  {cerr << e.what() << endl << "\n\n"; print_symbol('E');}

  return 0;
}
