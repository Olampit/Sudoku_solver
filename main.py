import csv
import time

class SudokuSolver:
    
    def __init__(self):
        self.calls = 0
        self.backtracks = 0
        self.start_time = 0
        self.end_time = 0

    def solve(self, grid):
        self.calls = 0
        self.backtracks = 0
        self.start_time = time.time()
        solved = self._backtrack(grid)
        self.end_time = time.time()
        return solved, self.calls, self.backtracks, self.end_time - self.start_time

    def _backtrack(self, grid):
        self.calls += 1
        # Find an empty cell (row, col) or finish if none
        empty = [(i, j) for i in range(9) for j in range(9) if grid[i][j] == 0]
        if not empty:
            return True
        # Pick the first empty cell
        row, col = empty[0]
        for num in range(1, 10):
            if self._is_safe(grid, row, col, num):
                grid[row][col] = num
                if self._backtrack(grid):
                    return True
                # Backtrack
                grid[row][col] = 0
                self.backtracks += 1
        return False

    def _is_safe(self, grid, row, col, num):
        # Check row and column
        if any(grid[row][j] == num for j in range(9)): return False
        if any(grid[i][col] == num for i in range(9)): return False
        # Check 3×3 block
        br, bc = (row // 3) * 3, (col // 3) * 3
        for i in range(br, br + 3):
            for j in range(bc, bc + 3):
                if grid[i][j] == num:
                    return False
        return True

    def load_from_txt(self, filename):
        grid = []
        with open(filename, 'r') as file:
            line = file.readline().strip()  # Read the first line
            # If the file contains a single long string, split it into a 9x9 grid
            if len(line) == 81:
                grid = [list(map(int, list(line[i:i+9]))) for i in range(0, 81, 9)]
            else:
                for line in file.readlines():
                    grid.append([int(x) if x.strip() else 0 for x in line.split()])
        return grid

    def load_from_csv(self, filename):
        grid = []
        with open(filename, 'r') as file:
            line = file.readline().strip()  # Read the first line
            # Split the string into a list of digits and convert them to integers
            grid = [list(map(int, list(line[i:i+9]))) for i in range(0, 81, 9)]
        return grid

    def save_to_txt(self, grid, filename):
        with open(filename, 'w') as file:
            for row in grid:
                file.write(' '.join(str(x) if x != 0 else '.' for x in row) + '\n')

    def save_to_csv(self, grid, filename):
        with open(filename, 'w', newline='') as file:
            writer = csv.writer(file)
            for row in grid:
                writer.writerow(row)
