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
        if file_path.endswith('.txt'):
            self.grid = self.solver.load_from_txt(file_path)
        elif file_path.endswith('.csv'):
            self.grid = self.solver.load_from_csv(file_path)
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
        for i in range(9):
            for j in range(9):
                value = self.grid[i][j]
                self.entries[i][j].delete(0, tk.END)
                if value != 0:
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
