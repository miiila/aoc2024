#include <algorithm>
#include <cstdlib>
#include <iostream>
#include <fstream>
#include <ostream>
#include <string>
#include <filesystem>
#include <vector>

using namespace std;

int main() {
  // ChatGPT block for file reading {
    // Specify the file path (change this to your file's path)
    const std::filesystem::path filePath = "../day1_input";

    // Open the file for reading
    ifstream file(filePath);

    vector<string> lines = {};

    // Read and display the file content
    string line;
    
    while (getline(file, line)) {
      lines.push_back(line);
    }

    // The file will be closed automatically when `file` goes out of scope
    vector<int> first = {};
    vector<int> second = {};
    for (string line : lines) {
      first.push_back(stoi(line.substr(0, line.find("   "))));
      second.push_back(stoi(line.substr(line.find("   "))));
  }
  // } ChatGPT

  sort(first.begin(), first.end());
  sort(second.begin(), second.end());
  
  int res = 0;

  // Part 1
  for (int i = 0; i < first.size(); i++) {
    res  = res + abs(first[i] - second[i]);
  }

  cout << res << endl;


  // Part 2
  res = 0;
  for (int v : first) {
    int c = 0;
    for (int w : second) {
      c = c + (1 ? v == w : 0);
    }
    res = res + (v * c);
  }

  cout << res << endl;

  return 0;
}
