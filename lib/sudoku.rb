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

    row = l[0]
    col = l[1]

    (1..9).each do |num|
      if is_possible_digit?(num, row, col)
        problem[row][col] = num
        if solve
          return problem
        end

        problem[row][col] = 0
      end
    end
    false
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

  def get_box(x, y)
    problem.transpose[y*3..y*3+2].each_with_object([]) do |arr, memo|
      memo << arr[x*3..x*3+2]
    end.transpose
  end

  def occurs_in_row?(digit, row)
    problem[row].include? digit
  end

  def occurs_in_column?(digit, column)
    problem.transpose[column].include? digit
  end

  def occurs_in_box?(digit, x, y)
    get_box(x, y).flatten.include? digit
  end

  def is_possible_digit?(digit, row=nil, column=nil)
    results = [
      occurs_in_box?(digit, row/3, column/3),
      occurs_in_row?(digit, row),
      occurs_in_column?(digit, column)
    ]
    !results.include? true
  end

  def is_only_possible_digit?(digit, row, column)
    results = (1..9).each_with_object([]) do |num, arr|
      arr << is_possible_digit?(num, row, column)
    end
    results.count(true) == 1 && results[digit-1]
  end

  def display
    puts "--------------------------"
    problem.each do |line|
      line.each do |num|
        if num == 0
          print " . "
        else
          print " #{num} "
        end
      end
      print "\n"
    end
    puts "--------------------------"
  end
end
