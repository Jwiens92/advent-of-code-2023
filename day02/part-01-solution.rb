# ---- PROBLEM START ----
# For example, the record of a few games might look like this:

# Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
# Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
# Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
# Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
# Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
# In game 1, three sets of cubes are revealed from the bag (and then put back again).
# The first set is 3 blue cubes and 4 red cubes; the second set is 1 red cube, 2 green cubes, and 6 blue cubes;
# the third set is only 2 green cubes.

# The Elf would first like to know which games would have been possible if the bag
# contained only 12 red cubes, 13 green cubes, and 14 blue cubes?

# In the example above, games 1, 2, and 5 would have been possible if the bag had been loaded with that configuration.
# However, game 3 would have been impossible because at one point the Elf showed you 20 red cubes at once; similarly,
# game 4 would also have been impossible because the Elf showed you 15 blue cubes at once. If you add up the IDs of
# the games that would have been possible, you get 8.

# Determine which games would have been possible if the bag had been loaded with only 12 red cubes, 13 green cubes, and 14 blue cubes. What is the sum of the IDs of those games?
# ---- PROBLEM END ----

FILE_NAME = 'input.txt'

RED_PLAY_MAX = 12
GREEN_PLAY_MAX = 13
BLUE_PLAY_MAX = 14

def filter_games
  valid_games_count = 0
  File.open(FILE_NAME).readlines.map(&:chomp).map do |current_line|
    match = /Game (\d+): (.*)/
    match = current_line.match(match)
    next unless match

    plays = match[2].split(';') # grab the groups separted into plays
    current_game = match[1] # game number for summing later

    game_valid = true

    plays.each do |play|
      current_scores = {
        red: 0,
        green: 0,
        blue: 0

      } # reset scores for each play
      play.scan(/(\d+) (\w+)/) do |number, color|
        current_scores[color.to_sym] += number.to_i
      end
      confirm_valid_game?(current_scores) || game_valid = false
    end

    valid_games_count += current_game.to_i if game_valid
  end

  valid_games_count
end

def confirm_valid_game?(current_scores)
  current_scores[:red] <= RED_PLAY_MAX &&
    current_scores[:green] <= GREEN_PLAY_MAX &&
    current_scores[:blue] <= BLUE_PLAY_MAX
end

# get that star!
puts filter_games