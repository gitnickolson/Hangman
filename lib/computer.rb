# frozen_string_literal: true

require 'csv'

class Computer
  def get_secret_word
    dictionary = []
    contents = CSV.open('dictionary.csv')

    contents.each do |word|
      dictionary << word
    end

    dictionary.sample.join(', ')
  end
end
