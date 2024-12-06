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
    const std::filesystem::path filePath = "../day6_input";

    // Open the file for reading
    ifstream file(filePath);

    vector<string> lines = {};

    // Read and display the file content
    string line;
    
    vector<vector<char>> grid = {};
    while (getline(file, line)) {
      vector<char> l;
      for (auto c : line) {
        l.push_back(c);
      }
      grid.push_back(l);
    }

  // } ChatGPT

  struct pos {
    int row;
    int col;
  };

    int dirs[4][2] = {{-1, 0}, {0,1}, {1,0}, {0,-1}};
    // cheat - I know the sizes
    bool visited[130][130];

    pos start;
    int i,j = 0;
    while (true) {
      if (grid[i][j] == '^') {
        start = pos{i,j};
        break; 
      }
      if (++j == grid[0].size()) {
        i++;
        j = 0;
      }
    }
  // Part 1
  int r = start.row;
  int c = start.col;
  int dir = 0;
  while (true) {
    visited[r][c] = true;
    int nr = r+dirs[dir][0];
    int nc = c+dirs[dir][1];
    if (nr < 0 || nr == grid.size() || nc < 0 || nc == grid[0].size()) {
      break;
    }
    if (grid[nr][nc] == '#') {
      dir = (dir + 1) % 4;
      nr = r+dirs[dir][0];
      nc = c+dirs[dir][1];
    }
    r = nr;
    c = nc;
  }

  int res = 0;
  for (int i = 0; i < 130; i++) {
    for (int j = 0; j < 130; j++) {
      res = res + visited[i][j];
    }
  }
  cout << res << endl;

  // Part 2
  res = 0;
  for (int i = 0; i < 130; i++) {
    for (int j = 0; j < 130; j++) {
      if (!visited[i][j] || i == start.row && j == start.col) {
        continue;
      }
        grid[i][j] = '#';
        bool visited_c[130][130][4];
        for (int x = 0; x < 130; x++) {
          for (int y = 0; y < 130; y++) {
            for (int z = 0; z < 4; z++) {
              visited_c[x][y][z] = false;
            }
          }
        }
        int r = start.row;
        int c = start.col;
        int dir = 0;
        while (true) {
          if (visited_c[r][c][dir]) {
            res++;
            break;
          }
          visited_c[r][c][dir] = true;
          int nr = r+dirs[dir][0];
          int nc = c+dirs[dir][1];
          if (nr < 0 || nr == 130 || nc < 0 || nc == 130) {
            break;
          }
          while (grid[nr][nc] == '#') {
            dir = (dir + 1) % 4;
            nr = r+dirs[dir][0];
            nc = c+dirs[dir][1];
          }
          r = nr;
          c = nc;
      }
        grid[i][j] = '.';
    }
  }
  cout << res << endl;
  
  return 0;
}
