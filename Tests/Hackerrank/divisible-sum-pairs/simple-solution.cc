#include <bits/stdc++.h>

using namespace std;

vector<string> split_string(string);

// Complete the divisibleSumPairs function below.
int divisibleSumPairs(int n, int k, vector<int> ar) {
  int mapping[k];
  int result{0};

  memset(mapping, 0, sizeof(int)*k);

  for (auto i = 0; i < int(ar.size()); ++i) {
    mapping[ar[i]%k] += 1;
  }

  for (auto i = 1; i < k/2 + 1; ++i) {
    result += mapping[k - i] * mapping[i];
  }

  result += mapping[0]*(mapping[0] - 1)/2;

  if (k % 2 == 0) {
    result += mapping[k/2]*(mapping[k/2] - 1)/2;
  }

  return result;
}

int main()
{
  char* path = getenv("OUTPUT_PATH");

  if (path) {
    ofstream fout(path);

    string nk_temp;
    getline(cin, nk_temp);

    vector<string> nk = split_string(nk_temp);

    int n = stoi(nk[0]);

    int k = stoi(nk[1]);

    string ar_temp_temp;
    getline(cin, ar_temp_temp);

    vector<string> ar_temp = split_string(ar_temp_temp);

    vector<int> ar(n);

    for (int i = 0; i < n; i++) {
        int ar_item = stoi(ar_temp[i]);

        ar[i] = ar_item;
    }

    int result = divisibleSumPairs(n, k, ar);

    fout << result << "\n";

    fout.close();
  } else {
    std::vector<std::tuple<int, int, std::vector<int>>> cases{};

    cases.push_back(std::make_tuple(6, 3, std::vector<int>({1, 3, 2, 6, 1, 2})));

    for (auto step: cases) {
      cout << divisibleSumPairs(std::get<0>(step), std::get<1>(step),
                                std::get<2>(step))
           << endl;
    }
  }
    
  return 0;
}

vector<string> split_string(string input_string) {
  string::iterator new_end = unique(input_string.begin(), input_string.end(), [] (const char &x, const char &y) {
    return x == y and x == ' ';
  });

  input_string.erase(new_end, input_string.end());

  while (input_string[input_string.length() - 1] == ' ') {
    input_string.pop_back();
  }

  vector<string> splits;
  char delimiter = ' ';

  size_t i = 0;
  size_t pos = input_string.find(delimiter);

  while (pos != string::npos) {
    splits.push_back(input_string.substr(i, pos - i));

    i = pos + 1;
    pos = input_string.find(delimiter, i);
  }

  splits.push_back(input_string.substr(i, min(pos, input_string.length()) - i + 1));

  return splits;
}
