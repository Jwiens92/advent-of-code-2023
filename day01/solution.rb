# ---- PROBLEM START ----
# The newly-improved calibration document consists of lines of text; each line originally contained a specific
# calibration value that the Elves now need to recover. On each line, the calibration value can be found by
# combining the first digit and the last digit (in that order) to form a single two-digit number.

# For example:

# 1abc2
# pqr3stu8vwx
# a1b2c3d4e5f
# treb7uchet
# In this example, the calibration values of these four lines are 12, 38, 15, and 77. Adding these together produces 142.

# Consider your entire calibration document. What is the sum of all of the calibration values?

# ---- PROBLEM END ----

# Solution Notes
# Runs O(n) per line
# Space complexity is O(1)
# Total run is O(L)


file_name = "input.txt"

def calibrate(file_name)
  total_calibration = 0
  File.open(file_name).readlines.map(&:chomp).map do |current_line|
    # position pointers at start and end of each line
    left_pointer = 0
    right_pointer = current_line.length - 1

    first_num = nil
    second_num = nil

    while (left_pointer <= right_pointer) # There may be only one number <= to account for that
      if first_num.nil? && convert_to_integer_if_numeric(current_line[left_pointer])
        first_num = current_line[left_pointer]
      end

      if second_num.nil? && convert_to_integer_if_numeric(current_line[right_pointer])
        second_num = current_line[right_pointer]
      end

      break unless first_num.nil? || second_num.nil?

      # stop incrementing or decrementing once number is found to account for only 1 number in some lines
      left_pointer += 1 if first_num.nil?
      right_pointer -= 1 if second_num.nil?
    end

    total_calibration += "#{first_num}#{second_num}".to_i
  end

  total_calibration
end

def convert_to_integer_if_numeric(str)
  str.match?(/\A-?\d+\z/) ? str.to_i : nil
end

# get that star!
puts calibrate(file_name)
