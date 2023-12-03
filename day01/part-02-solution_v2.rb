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
# OK this came to me when I was half way through v1
# long story short convert the line before trying to find the numbers
# could have cleaned up more but I'm burnt and its only day 1
# slightly less efficeint O(n * 5) bcause of the word replacement function
# space complixity is still O(1)


file_name = "input.txt"

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


def calibrate(file_name)
  total_calibration = 0
  File.open(file_name).readlines.map(&:chomp).map do |current_line|
    # position pointers at start and end of each line
    puts_with_text('original_line') { current_line }
    current_line = convert_words_to_numbers(current_line)
    puts_with_text('convernt_line') { current_line }
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

def puts_with_text(text)
  puts "#{text}: #{yield}"
end

def convert_words_to_numbers(line)
  left_pointer = 0
  right_pointer = left_pointer + 1

  while(left_pointer < line.length)
    possible_word = line.slice(left_pointer..right_pointer)
    if WORDED_NUMBER_MAP[possible_word]
      index_of_word = line.index(possible_word)
      line = line.sub(possible_word, WORDED_NUMBER_MAP[possible_word] + line[right_pointer])
      left_pointer = index_of_word
      right_pointer = left_pointer + 1
    else
      if (right_pointer - left_pointer < 5)
        right_pointer += 1
      else
        left_pointer += 1
        right_pointer = left_pointer + 1
      end
    end
  end
  line
end

def convert_to_integer_if_numeric(str)
  str.match?(/\A-?\d+\z/) ? str.to_i : nil
end

# get that second star!
puts calibrate(file_name)
