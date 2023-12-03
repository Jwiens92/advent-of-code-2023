# ---- PROBLEM START ----

# Your calculation isn't quite right. It looks like some of the digits are actually spelled out with letters: one, two,
# three, four, five, six, seven, eight, and nine also count as valid "digits".

# Equipped with this new information, you now need to find the real first and last digit on each line. For example:

# two1nine
# eightwothree
# abcone2threexyz
# xtwone3four
# 4nineeightseven2
# zoneight234
# 7pqrstsixteen
# In this example, the calibration values are 29, 83, 13, 24, 42, 14, and 76. Adding these together produces 281.

# ---- PROBLEM END ----

# Solution Notes
# This could have worked but I came up with a much simpler solution halfway through
# leaving for for posterity
# it was not finsihed nor cleaned up don't judge me


FILE_NAME = "input.txt"

WORDED_NUMBER_MAP = {
  'one' => '1',
  'two' => '2',
  'three' => '3',
  'four' => '4',
  'five' => '5',
  'six' => '6',
  'seven' => '7',
  'eight' => '8',
  'nine' => '9'
}

MAX_LETTER_NUM_COUNT = 5

def calibrate
  total_calibration = 0
  File.open(FILE_NAME).readlines.map(&:chomp).map do |current_line|
    # position pointers at start and end of each line
    left_pointer = 0
    right_pointer = current_line.length - 1

    first_num = nil
    second_num = nil

    while left_pointer <= right_pointer # There may be only one number <= to account for that
      if first_num.nil? && convert_to_integer_if_numeric(current_line[left_pointer])
        first_num = current_line[left_pointer]
      else
        if first_num.nil?
          slice_start = left_pointer # starting letter
          end_slice = left_pointer + 1
          #puts_with_text('slice_start, end_slice') { "(#{slice_start},#{end_slice})" }
          while (end_slice - slice_start) <= MAX_LETTER_NUM_COUNT
            if convert_to_integer_if_numeric(current_line[end_slice]) # if we hit a number, we're done
              left_pointer = end_slice
              first_num = current_line[left_pointer]
              break
            end
            #puts_with_text('slice_slice_start, slice_end_slice') { "(#{slice_start},#{end_slice})" }
            possible_number = current_line.slice(slice_start..end_slice)
            #puts_with_text('left possible_number') { possible_number }

            if WORDED_NUMBER_MAP[possible_number]
              first_num = WORDED_NUMBER_MAP[possible_number]
              left_pointer = end_slice
              break
            end
            end_slice += 1
          end
          left_pointer = slice_start
        end
      end

      if second_num.nil? && convert_to_integer_if_numeric(current_line[right_pointer])
        second_num = current_line[right_pointer]
      else
        if second_num.nil?
          slice_start = right_pointer # starting letter
          end_slice = right_pointer - 1
          while (slice_start - end_slice) <= MAX_LETTER_NUM_COUNT
            if convert_to_integer_if_numeric(current_line[slice_start]) # if we hit a number, we're done
              right_pointer = slice_start
              second_num = current_line[right_pointer]
              break
            end
            # puts_with_text('end_slice..slice_start') { "(#{end_slice},#{slice_start})" }
            possible_number = current_line.slice(end_slice..slice_start)
            # puts_with_text('right possible_number') { possible_number }

            if WORDED_NUMBER_MAP[possible_number]
              second_num = WORDED_NUMBER_MAP[possible_number]
              right_pointer = end_slice
              break
            end
            end_slice -= 1
          end
          right_pointer = slice_start
        end
      end

      break unless first_num.nil? || second_num.nil?

      # stop incrementing or decrementing once number is found to account for only 1 number in some lines
      left_pointer += 1 if first_num.nil?
      right_pointer -= 1 if second_num.nil?
    end

    puts_with_text('first_num') { first_num }
    puts_with_text('second_num') { second_num }
    puts '-------------'
    total_calibration += "#{first_num}#{second_num}".to_i
  end

  total_calibration
end

def puts_with_text(text)
  puts "#{text}: #{yield}"
end

def convert_to_integer_if_numeric(str)
  return if str.nil?
  str.match?(/\A-?\d+\z/) ? str.to_i : nil
end

# get that star!
puts calibrate()
