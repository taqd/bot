
#include "../../libs/bot.hpp"

int main(int argc, char* argv[]) {
  string pred_file{argv[2]}, label_file{argv[1]}, tmp;
  vector<int> preds, labels;

  ifstream inp{pred_file}; if (!inp) {cerr << "no pred file"; return 1;}
  while (inp >> tmp) preds.push_back(stoi(tmp));

  ifstream inl{label_file}; if (!inl) {cerr << "no label file"; return 1;}
  while (inl >> tmp) labels.push_back(stoi(tmp));

  if (preds.size() != labels.size()) { 
    cout << "bad: mismatching sizes\n";
    return 1;
  }
  int sz = preds.size();
  int memory = 1440;
  float num{0}, correct_side{0}, correct_label{0}, num_highs{0}, correct_highs{0},zeros{0};
  float ones{0}, twos{0}, threes{0}, fours{0}, fives{0};
  float onesc{0}, twosc{0}, threesc{0}, foursc{0}, fivesc{0};
  float wrong_label{0};
  for (int i = 0; i < preds.size() - 1 && i < memory; ++i) {
    int label = labels[preds.size() - 1 - i], 
        pred = preds[preds.size() - 1 - i];
    if (label == 1) ones++;
    if (label == 2) twos++;
    if (label == 3) threes++;
    if (label == 4) fours++;
    if (label == 5) fives++;
    if (label == 1 && pred == 1) onesc++;
    if (label == 2 && pred == 2) twosc++;
    if (label == 3 && pred == 3) threesc++;
    if (label == 4 && pred == 4) foursc++;
    if (label == 5 && pred == 5) fivesc++;
 
    if (label == pred)
      correct_label++;
    if (label != pred)
      wrong_label++;
    if (label ==3)
      zeros++;

    if (label > 3 && pred == 4)
      correct_side++;
    else if (label < 3 && pred == 2) 
      correct_side++;
    else if (label == 3 && pred == 3)
      correct_side++;

    if (pred != 4 && pred > 3) {
      num_highs++;
            cerr << pred << " -- " <<  pred_file << endl;
    }
    if ((label == 5 && pred == 5) || (label == 1 && pred == 1)) 
      correct_highs++;
    num++;
  }
  float correct = (correct_side / num) * 100;

  float correcth = (correct_side)/10;
  cout << fixed << setprecision(0) << correct << endl;
  return 0;
}



