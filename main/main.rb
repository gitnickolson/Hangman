require "csv"

class Game
  attr_accessor :com, :player, :turns_left, :feedback, :secret_word, :player_name, :STARTING_TURNS
  STARTING_TURNS = 12

  def initialize
    @com = Computer.new
    @player = Player.new
    @turns_left = STARTING_TURNS
  end

  def start
    puts "Welcome to Hangman! What's your name?"
    @player_name = player.get_name.downcase
    @secret_word = com.get_secret_word.chars
    @feedback = Array.new(secret_word.length, "_")

    print_feedback_array
    game_loop
  end

  def game_loop
    until turns_left == 0
      game_turn
    end
  end

  def game_turn
    if turns_left == 12
      puts "Please enter your guess. You can also save(1) the game or load(2) your previous game!"
    else
      puts "Please enter your guess"
    end

    player_input = player.get_player_input
    case player_input
    when "1"
      save_game
    when "2"
      load_game
    end

    secret_word.each_with_index do |letter, index|
      if player_input == letter
        feedback[index] = letter
      end
    end
    print_feedback_array

    if player_input != "1" and player_input != "2"
      @turns_left -= 1
    end
    game_evaluation
  end

  def print_feedback_array
    p feedback.join
  end

  def game_evaluation
    if feedback == secret_word
      evaluation_output(:game_won)
      turns_left = 0
    elsif turns_left == 0
      evaluation_output(:game_lost)
    else
      evaluation_output(:still_running)
    end
  end

  def evaluation_output(game_state = :still_running)
    case game_state
    when :game_won
      puts "You win after #{10 - turns_left} turns!"

    when :game_lost
      puts "You lose!"
      puts "The correct word would have been \"#{secret_word.join("")}\""

    when :still_running
      puts "Turns left: #{turns_left}"
    end
  end

  def save_game
    Dir.mkdir("saves") unless Dir.exist?("saves")
    filename = "saves/#{player_name}_save.txt"

    File.open(filename, 'w') do |file|
      file.print "#{secret_word.join("")} - "
      file.print "#{feedback.join("")} - "
      file.print "#{turns_left}"
    end
  end

  def load_game
    begin
      save_file = File.open("saves/#{player_name}_save.txt").first

      save_file = save_file.split(" - ")
      save_file[0] = save_file[0].chars
      save_file[1] = save_file[1].chars
      save_file[2] = save_file[2].to_i

      @secret_word = save_file[0]
      @feedback = save_file[1]
      @turns_left = save_file[2]
    rescue
      puts "You don't have a save file yet!"
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

  def get_name
    name = gets.chomp
  end
end

game = Game.new
game.start