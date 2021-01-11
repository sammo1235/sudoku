require 'byebug'
class Sudoku
  attr_accessor :problem, :l
  def initialize(problem)
    @problem = problem
    @l = [0,0]
  end

  def solve
    if !find_empty
      return problem
    end
    row = l[0]; col = l[1]
    possibles(row, col).each do |num|
      problem[row][col] = num
      if solve
        return problem
      end

      problem[row][col] = 0
    end
    false
  end

  def possibles(row, col)
    (1..9).to_a - get_box(row, col).flatten - problem[row] - problem.transpose[col]
  end

  def find_empty
    (0..8).each do |x|
      (0..8).each do |y|
        if problem[x][y] == 0
          l[0] = x
          l[1] = y
          return true
        end
      end
    end
    false
  end

  def get_box(row, col)
    x = row / 3
    y = col / 3
    problem.transpose[y*3..y*3+2].each_with_object([]) do |arr, memo|
      memo << arr[x*3..x*3+2]
      memo
    end.transpose
  end
end
