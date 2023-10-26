# frozen_string_literal: true

class Player
  def get_player_input
    letter = gets.chomp
    letter[0]
  end

  def get_name
    gets.chomp
  end
end
