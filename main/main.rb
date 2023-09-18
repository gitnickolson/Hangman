require "csv"

class Game
  attr_accessor :com, :player, :turns_left, :feedback, :secret_word, :starting_turns

  def initialize
    @com = Computer.new
    @player = Player.new
    @starting_turns = 12
    @turns_left = starting_turns
  end

  def start
    puts "Welcome to Hangman!"
    @secret_word = com.get_secret_word.chars
    @feedback = Array.new(secret_word.length)
    game_loop
  end

  def game_loop
    until turns_left == 0
      game_turn
    end
  end

  def game_turn
    if turns_left == starting_turns
      secret_word.each_with_index do |letter, index|
        feedback[index] = "_"
      end
      print_feedback_array
    end

    puts "Please enter your guess:"
    player_guess = player.get_player_input

    secret_word.each_with_index do |letter, index|
      if player_guess == letter
        feedback[index] = letter
      end
    end
    print_feedback_array

    @turns_left -= 1
    game_evaluation
  end

  def print_feedback_array
    p feedback.join
  end

  def game_evaluation
    if feedback == secret_word
      evaluation_output(0)
      @turns_left = 0
    elsif turns_left == 0
      evaluation_output(1)
    else
      evaluation_output(2)
    end
  end

  def evaluation_output(game_won = 2)
    case game_won
    when 0
      puts "You win after #{10 - turns_left} turns!"

    when 1
      puts "You lose!"
      puts "The correct word would have been \"#{secret_word.join("")}\""

    when 2
      puts "Turns left: #{turns_left}"
    end
  end
end


class Computer
  def get_secret_word
    dictionary = Array.new
    contents = CSV.open("dictionary.csv")

    contents.each do |word|
      dictionary << word
    end

    dictionary.sample.join(", ")
  end
end


class Player
  def get_player_input
    letter = gets.chomp
    letter[0]
  end
end


game = Game.new
game.start