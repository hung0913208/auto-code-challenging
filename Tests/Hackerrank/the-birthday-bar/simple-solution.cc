#include <bits/stdc++.h>

using namespace std;

string ltrim(const string &);
string rtrim(const string &);
vector<string> split(const string &);

// Complete the birthday function below.
int birthday(vector<int> s, int d, int m) { 
  int sum[s.size()], result{0};

  memset(sum, 0, sizeof(int)*s.size());

  for (auto i = 0; i < int(s.size()); ++i) {
    for (auto j = 0; j < m; ++j) {
      if (i - j >= 0) {
        sum[i - j] += s[i];
      } else {
        break;
      }
    }

    if (i >= (m - 1)) {
      result += (sum[i - (m - 1)] == d);
    }
  }

  return result;
}

int main() {  
  char* path = getenv("OUTPUT_PATH");

  if (path) {
    ofstream fout(path);

    string n_temp;
    getline(cin, n_temp);

    int n = stoi(ltrim(rtrim(n_temp)));

    string s_temp_temp;
    getline(cin, s_temp_temp);
  
    vector<string> s_temp = split(rtrim(s_temp_temp));

    vector<int> s(n);

    for (int i = 0; i < n; i++) {
      int s_item = stoi(s_temp[i]);

      s[i] = s_item;
    }

    string dm_temp;
    getline(cin, dm_temp);

    vector<string> dm = split(rtrim(dm_temp));

    int d = stoi(dm[0]);

    int m = stoi(dm[1]);

    int result = birthday(s, d, m);

    fout << result << "\n";

    fout.close();
  } else {
    std::vector<std::tuple<std::vector<int>, int, int>> cases{};

    cases.push_back(std::make_tuple(std::vector<int>({1, 2, 1, 3, 2}), 3, 2));
    cases.push_back(std::make_tuple(std::vector<int>({4}), 4, 1));
    cases.push_back(std::make_tuple(std::vector<int>({1, 1, 1, 1, 1, 1}), 3, 2));
                    
    for (auto step : cases) {
      cout << birthday(std::get<0>(step), std::get<1>(step), std::get<2>(step))
           << endl;
    }
  }
  return 0;
}

string ltrim(const string &str) {
  string s(str);

  s.erase(
      s.begin(),
      find_if(s.begin(), s.end(), not1(ptr_fun<int, int>(isspace)))
  );

  return s;
}

string rtrim(const string &str) {
  string s(str);

  s.erase(
      find_if(s.rbegin(), s.rend(), not1(ptr_fun<int, int>(isspace))).base(),
      s.end()
  );

  return s;
}

vector<string> split(const string &str) {
  vector<string> tokens;

  string::size_type start = 0;
  string::size_type end = 0;

  while ((end = str.find(" ", start)) != string::npos) {
      tokens.push_back(str.substr(start, end - start));

      start = end + 1;
  }

  tokens.push_back(str.substr(start));

  return tokens;
}
