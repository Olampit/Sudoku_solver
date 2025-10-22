import tkinter as tk
from tkinter import filedialog, messagebox
from tkinter import ttk
from main import SudokuSolver

class SudokuGUI:
    def __init__(self, root, solver):
        self.root = root
        self.solver = solver
        self.grid = [[0]*9 for _ in range(9)]
        self.create_widgets()

    def parse_puzzle_file(self, path):
        """
        Read a puzzle file and return a 9x9 grid (list of lists of ints).
        Accepts:
        - 9 lines of 9 numbers separated by spaces or commas
        - 9 lines each with 9 digits (no separators)
        - a single line with 81 digits
        Raises ValueError on malformed content.
        """
        with open(path, 'r', encoding='utf-8-sig') as f:
            lines = [ln.strip() for ln in f.readlines() if ln.strip() != '']

        if not lines:
            raise ValueError("File is empty")

        # Single-line 81 chars (spaces/commas removed)
        if len(lines) == 1:
            s = lines[0].replace(' ', '').replace(',', '')
            if len(s) == 81:
                grid = []
                for i in range(9):
                    row = []
                    for j in range(9):
                        ch = s[i*9 + j]
                        if ch in ('.', '_', '-'):
                            row.append(0)
                        else:
                            try:
                                row.append(int(ch))
                            except ValueError:
                                raise ValueError(f"Invalid character '{ch}' in puzzle.")
                    grid.append(row)
                return grid

        # Expect 9 lines
        if len(lines) == 9:
            grid = []
            for idx, ln in enumerate(lines):
                # try comma separated first, then whitespace
                if ',' in ln:
                    parts = [p.strip() for p in ln.split(',') if p.strip() != '']
                else:
                    parts = [p for p in ln.split() if p != '']

                # handle contiguous 9-digit string per line
                if len(parts) == 1 and len(parts[0]) == 9:
                    parts = list(parts[0])

                if len(parts) != 9:
                    raise ValueError(f"Line {idx+1} does not contain 9 entries: '{ln}'")

                row = []
                for token in parts:
                    if token == '' or token in ('.','_','-'):
                        row.append(0)
                    else:
                        try:
                            row.append(int(token))
                        except ValueError:
                            raise ValueError(f"Invalid token '{token}' on line {idx+1}")
                grid.append(row)
            return grid

        raise ValueError("Puzzle file must be either one 81-character line or 9 lines of 9 entries.")


    def create_widgets(self):
        self.root.title("Sudoku Solver")

        # Create a grid
        self.entries = [[None] * 9 for _ in range(9)]
        for i in range(9):
            for j in range(9):
                self.entries[i][j] = tk.Entry(self.root, width=3, font=("Arial", 18), justify="center")
                self.entries[i][j].grid(row=i, column=j, padx=5, pady=5)

        # Solve button
        self.solve_button = tk.Button(self.root, text="Solve", font=("Arial", 14), command=self.solve_sudoku)
        self.solve_button.grid(row=10, column=0, columnspan=9, pady=10)

        # File Load and Save buttons
        self.load_button = tk.Button(self.root, text="Load from File", font=("Arial", 14), command=self.load_file)
        self.load_button.grid(row=11, column=0, columnspan=9, pady=10)

        self.save_button = tk.Button(self.root, text="Save to File", font=("Arial", 14), command=self.save_file)
        self.save_button.grid(row=12, column=0, columnspan=9, pady=10)


        self.metrics_label = tk.Label(self.root, text="Metrics: ", font=("Arial", 12))
        self.metrics_label.grid(row=13, column=0, columnspan=9)

    def load_file(self):
        file_path = filedialog.askopenfilename(filetypes=[("Text Files", "*.txt"), ("CSV Files", "*.csv")])
        if file_path:
            self.load_puzzle(file_path)

    def load_puzzle(self, file_path):
        # Use robust parser and handle exceptions gracefully
        try:
            # use the parser above to get a 9x9 grid
            parsed_grid = self.parse_puzzle_file(file_path)
        except Exception as e:
            messagebox.showerror("Load error", f"Failed to load puzzle:\n{e}")
            return

        # Set internal grid and update UI
        self.grid = parsed_grid
        self.update_grid()


    def solve_sudoku(self):
        # current puzzle
        for i in range(9):
            for j in range(9):
                try:
                    self.grid[i][j] = int(self.entries[i][j].get() or 0)
                except ValueError:
                    self.grid[i][j] = 0

        solved, calls, backtracks, exec_time = self.solver.solve(self.grid)

        if solved:
            self.update_grid()
            messagebox.showinfo("Success", f"Sudoku solved!\nCalls: {calls}\nBacktracks: {backtracks}\nExecution Time: {exec_time:.4f} seconds")
        else:
            messagebox.showerror("Error", "No solution found!")

    def update_grid(self):
        # Validate shape before touching entries
        if not (isinstance(self.grid, list) and len(self.grid) == 9 and all(isinstance(r, list) and len(r) == 9 for r in self.grid)):
            messagebox.showerror("Internal error", "Loaded puzzle is not a valid 9x9 grid.")
            return

        for i in range(9):
            for j in range(9):
                value = self.grid[i][j]
                self.entries[i][j].delete(0, tk.END)
                if isinstance(value, int) and value != 0:
                    self.entries[i][j].insert(0, str(value))


    def save_file(self):
        file_path = filedialog.asksaveasfilename(defaultextension=".txt", filetypes=[("Text Files", "*.txt"), ("CSV Files", "*.csv")])
        if file_path:
            if file_path.endswith('.txt'):
                self.solver.save_to_txt(self.grid, file_path)
            elif file_path.endswith('.csv'):
                self.solver.save_to_csv(self.grid, file_path)
            messagebox.showinfo("Success", f"Puzzle saved to {file_path}")

def main():
    root = tk.Tk()
    solver = SudokuSolver()
    app = SudokuGUI(root, solver)
    root.mainloop()

if __name__ == "__main__":
    main()
