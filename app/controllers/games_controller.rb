require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = (0...10).map { ('A'..'Z').to_a.sample }
  end

  def english_word(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_dictionary = open(url).read
    word_data = JSON.parse(word_dictionary)
    word_data['found']
  rescue StandardError => e
    puts "Error checking word: #{e.message}"
    false
  end

  def letter_in_grid(answer, grid)
    answer.chars.all? { |letter| grid.include?(letter) }
  end

  def score
    @grid = params[:grid]
    @answer = params[:word]

    if !letter_in_grid(@answer, @grid)
      @result = "Sorry, but #{@answer.upcase} can’t be built out of #{@grid}."
    elsif !english_word(@answer)
      @result = "Sorry but #{@answer.upcase} does not seem to be an English word."
    else
      @result = "Congratulations! #{@answer.upcase} is a valid English word."
    end
  end
end
