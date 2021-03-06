require 'pry'
require 'benchmark'

matrix = [[".",".",".","1","4",".",".","2","."],
 [".",".","6",".",".",".",".",".","."],
 [".",".",".",".",".",".",".",".","."],
 [".",".","1",".",".",".",".",".","."],
 [".","6","7",".",".",".",".",".","9"],
 [".",".",".",".",".",".","8","1","."],
 [".","3",".",".",".",".",".",".","6"],
 [".",".",".",".",".","7",".",".","."],
 [".",".",".","5",".",".",".","7","."]]

 matrix2 = [[".",".",".",".","2",".",".","9","."],
 [".",".",".",".","6",".",".",".","."],
 ["7","1",".",".","7","5",".",".","."],
 [".","7",".",".",".",".",".",".","."],
 [".",".",".",".","8","3",".",".","."],
 [".",".","8",".",".","7",".","6","."],
 [".",".",".",".",".","2",".",".","."],
 [".","1",".","2",".",".",".",".","."],
 [".","2",".",".","3",".",".",".","."]]

 matrix3 = [[".",".",".",".",".",".","5",".","."],
 [".",".",".",".",".",".",".",".","."],
 [".",".",".",".",".",".",".",".","."],
 ["9","3",".",".","2",".","4",".","."],
 [".",".","7",".",".",".","3",".","."],
 [".",".",".",".",".",".",".",".","."],
 [".",".",".","3","4",".",".",".","."],
 [".",".",".",".",".","3",".",".","."],
 [".",".",".",".",".","5","2",".","."]]

 matrix4 = [[".",".",".",".",".",".",".",".","2"],
 [".",".",".",".",".",".","6",".","."],
 [".",".","1","4",".",".","8",".","."],
 [".",".",".",".",".",".",".",".","."],
 [".",".",".",".",".",".",".",".","."],
 [".",".",".",".","3",".",".",".","."],
 ["5",".","8","6",".",".",".",".","."],
 [".","9",".",".",".",".","4",".","."],
 [".",".",".",".","5",".",".",".","."]]

 matrix5 = [
 [".","4",".",".",".",".",".",".","."],
 [".",".","4",".",".",".",".",".","."],
 [".",".",".","1",".",".","7",".","."],
 [".",".",".",".",".",".",".",".","."],
 [".",".",".","3",".",".",".","6","."],
 [".",".",".",".",".","6",".","9","."],
 [".",".",".",".","1",".",".",".","."],
 [".",".",".",".",".",".","2",".","."],
 [".",".",".","8",".",".",".",".","."]
]

def sudoku2(grid)
  check_rows(chunk_grids(grid)) &&
    check_rows(grid) &&
    check_rows(grid.transpose.map &:reverse)
end

def check_rows(grid)
  grid.all? do |row|
    last = nil
    row.sort.all? do |num|
      return false if num == last && num != '.'
      last = num
    end
  end
end

def chunk_grids(grid)
  hash = Hash.new { |h, k| h[k] = [] }
  grid.each_with_index do |row, i|
    row.each_with_index do |num, j|
      grid_num = (j/3).floor + ((i/3).floor * 3)
      hash[grid_num] << num
    end
  end
  hash.map { |h| h[1] }
end

Benchmark.bm do |x|
  x.report { puts sudoku2(matrix) }
  # puts sudoku2(matrix2)
  # puts sudoku2(matrix3)
  # puts sudoku2(matrix4)
  x.report { puts sudoku2(matrix5) }
end
