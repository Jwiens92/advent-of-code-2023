# ---- PROBLEM START ----
# The engineer explains that an engine part seems to be missing from the engine, but nobody can figure out which one.
# If you can add up all the part numbers in the engine schematic, it should be easy to work out which part is missing.

# The engine schematic (your puzzle input) consists of a visual representation of the engine. There are lots of numbers
# and symbols you don't really understand, but apparently any number adjacent to a symbol, even diagonally,
# is a "part number" and should be included in your sum. (Periods (.) do not count as a symbol.)

# Here is an example engine schematic:

# 467..114..
# ...*......
# ..35..633.
# ......#...
# 617*......
# .....+.58.
# ..592.....
# ......755.
# ...$.*....
# .664.598..
# In this schematic, two numbers are not part numbers because they are not adjacent to a symbol: 114 (top right) and 58
# (middle right). Every other number is adjacent to a symbol and so is a part number; their sum is 4361.

# Of course, the actual engine schematic is much larger. What is the sum of all of the part numbers in the engine
# schematic?
# ---- PROBLEM END ----

SPECIAL_CHARS = "*/$+&@#%=-"

def get_that_star
  matrix = extract_matrix

  window_start = 0
  window_end = 1
  valid_engine_part_numbers = []
  @current_number = ""

  matrix.each_with_index do |row, index|
    window_start = 0
    window_end = 1
    while window_end <= row.length
      valid = false
      if row[window_start].is_a?(Integer)
        @current_number.concat(row[window_start].to_s)

        # Move window end till we hit a non-integer
        while window_end <= row.length && row[window_end].is_a?(Integer)
          @current_number.concat(row[window_end].to_s)
          window_end += 1
        end

        window_end -= 1 # move back one space to the Integer

        valid = check_sides(row, window_start, window_end)
        valid = check_upper_lower(matrix, row, index, window_start, window_end) unless valid

        # move window to next non integer
        window_start = window_end + 1
        window_end = window_start + 1

        valid_engine_part_numbers << @current_number.to_i if valid
        # reset
        @current_number = ""
      else
        window_start += 1
        window_end += 1
      end
    end
  end

  puts valid_engine_part_numbers
  valid_engine_part_numbers.sum
end

def check_sides(row, window_start, window_end)
  return true if window_start != 0 && SPECIAL_CHARS.include?(row[window_start - 1])

  true if window_end != row.length - 1 && SPECIAL_CHARS.include?(row[window_end + 1])
end

def check_upper_lower(matrix, row, index, window_start, window_end)
  window_start -= 1 unless window_start == 0 # expand window to account for diagonol
  window_end += 1 unless window_end == row.length - 1

  return true if index != 0 && check_slice_for_special_chars(matrix, index - 1, window_start, window_end)

  true if index != matrix.length - 1 && check_slice_for_special_chars(matrix, index + 1, window_start, window_end)

end

def check_slice_for_special_chars(matrix, index, window_start, window_end)
  matrix[index].slice(window_start..window_end).intersection(SPECIAL_CHARS.chars).any?
end

def extract_matrix
  File.open('input.txt').readlines.map(&:chomp).map do |line|
    line.chars.map do |char|
      char.match(/\d/) ? char.to_i : char
    end
  end
end

puts get_that_star
