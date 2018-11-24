from tkinter import Tk, Canvas, Menu, Frame, Button, BOTH, TOP, BOTTOM, LEFT, messagebox
from tkinter.filedialog import askopenfilename 

from pyswip import Prolog


MARGIN = 20  # Pixels around the board
SIDE = 50  # Width of every board cell.
WIDTH = HEIGHT = MARGIN * 2 + SIDE * 9  # Width and height of the whole board


class Sudoku(Frame):

    def __init__(self, parent):
        Frame.__init__(self, parent)

        self.puzzle = [[0 for _ in range(9)] for _ in range(9)]
        self.solutions = None
        self.row = -1
        self.col = -1

        self.prolog = Prolog()
        self.prolog.consult('./sudoku.pl')

        self.parent = parent
        self.parent.title("Sudoku Solver")

        self.pack(fill=BOTH)

        self.canvas = Canvas(self,
                             width=WIDTH,
                             height=HEIGHT)
        self.canvas.pack(fill=BOTH, side=TOP)
        self.canvas.bind("<Button-1>", self._cell_clicked)
        self.canvas.bind("<Key>", self._key_pressed)
        self.canvas.bind("<Left>", self._go_left)
        self.canvas.bind("<Right>", self._go_right)
        self.canvas.bind("<Up>", self._go_up)
        self.canvas.bind("<Down>", self._go_down)

        f = Frame(width=100)
        f.pack()

        solve_btn = Button(f, text="Solve", command=self._solve)
        solve_btn.pack(side=LEFT)

        load_btn = Button(f, text="Load", command=self._load_file)
        load_btn.pack(side=LEFT)

        clear_btn = Button(f, text="Clear", command=self._clear)
        clear_btn.pack(side=LEFT)

        self._draw_grid()
        self._draw_puzzle()

    def _solve(self):
        if self.solutions:
            try:
                solution = next(self.solutions)
            except StopIteration:
                messagebox.showinfo('Error', 'There are no more solutions.')
                self.solutions = None
            else:
                self.puzzle = solution['Rows']
                self._draw_puzzle()
        else:
            board = '[' + ','.join('[' + ','.join('_' if n == 0 else str(n) for n in row) + ']' for row in self.puzzle) + ']'
            query = 'Rows = {}, solve([ff], Rows)'.format(board)
            self.solutions = self.prolog.query(query)
            self._solve()

    def _load_file(self):
        filename = askopenfilename()
        lines = []
        with open(filename) as f:
            for i, line in enumerate(f):
                self.puzzle[i] = [int(c) for c in line.strip()]

        self._draw_puzzle()
        self._draw_cursor()        

    def _clear(self):
        for i in range(9):
            for j in range(9):
                self.puzzle[i][j] = 0

        self._draw_puzzle()

    def _cell_clicked(self, event):
        x, y = event.x, event.y
        if (MARGIN < x < WIDTH - MARGIN and MARGIN < y < HEIGHT - MARGIN):
            self.canvas.focus_set()

            # get row and col numbers from x,y coordinates
            row, col = (y - MARGIN) // SIDE, (x - MARGIN) // SIDE

            #if cell was selected already - deselect it
            if (row, col) == (self.row, self.col):
                self.row, self.col = -1, -1
            else:
                self.row = row
                self.col = col
        else:
            self.row, self.col = -1, -1

        self._draw_cursor()

    def _go_up(self, event):
        if 1 <= self.row <= 8:
            self.row -= 1
            self._draw_cursor()

    def _go_down(self, event):
        if 0 <= self.row <= 7:
            self.row += 1
            self._draw_cursor()

    def _go_right(self, event):
        if 0 <= self.col <= 7:
            self.col += 1
            self._draw_cursor()

    def _go_left(self, event):
        if 1 <= self.col <= 8:
            self.col -= 1
            self._draw_cursor()

    def _key_pressed(self, event):
        if self.row >= 0 and self.col >= 0 and event.char.isdigit():
            self.puzzle[self.row][self.col] = int(event.char)
            self._draw_puzzle()
            self._draw_cursor()

    def _draw_puzzle(self, clear=True, puzzle=None, color='black'):
        if clear:
            self.canvas.delete("numbers")

        for i, row in enumerate(puzzle or self.puzzle):
            for j, cell in enumerate(row):
                if cell != 0:
                    x = MARGIN + j * SIDE + SIDE / 2
                    y = MARGIN + i * SIDE + SIDE / 2
                    self.canvas.create_text(x, y, text=cell, 
                                            tags='numbers', fill=color)

    def _draw_cursor(self):
        self.canvas.delete('cursor')
        if self.row >= 0 and self.col >= 0:
            x0 = MARGIN + self.col * SIDE + 1
            y0 = MARGIN + self.row * SIDE + 1
            x1 = MARGIN + (self.col + 1) * SIDE - 1
            y1 = MARGIN + (self.row + 1) * SIDE - 1
            self.canvas.create_rectangle(x0, y0, x1, y1,
                                         outline='red', tags='cursor')

    def _draw_grid(self):
        for i in range(10):
            color = 'blue' if i % 3 == 0 else 'gray'

            x0 = MARGIN + i * SIDE
            y0 = MARGIN
            x1 = MARGIN + i * SIDE
            y1 = HEIGHT - MARGIN
            self.canvas.create_line(x0, y0, x1, y1, fill=color)

            x0 = MARGIN
            y0 = MARGIN + i * SIDE
            x1 = WIDTH - MARGIN
            y1 = MARGIN + i * SIDE
            self.canvas.create_line(x0, y0, x1, y1, fill=color)


def main():
    root = Tk()
    Sudoku(root)
    root.geometry("{}x{}".format(WIDTH, HEIGHT + 40))
    root.mainloop()


if __name__ == '__main__':
    main() 
