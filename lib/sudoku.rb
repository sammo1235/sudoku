class Sudoku
  attr_accessor :problem
  def initialize(problem)
    @problem = problem
  end

  def solve
    buffer = 0
    while problem.flatten.include? 0
      break if buffer > 2000
      (0..8).each do |row|
        (0..8).each do |column|
          if get_digit(row, column) == 0
            answer = get_only_possible_digit(row, column)
            problem[row][column] = answer
            if answer != 0
              display
            else
              buffer += 1
            end
          else
            next
          end
        end
      end
    end
    problem
  end

  def get_digit(row, column)
    problem[row][column]
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

  def get_only_possible_digit(row, column)
    result = 0
    (1..9).each do |num|
      if is_only_possible_digit?(num, row, column)
        result = num
        break
      end
    end
    result
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
