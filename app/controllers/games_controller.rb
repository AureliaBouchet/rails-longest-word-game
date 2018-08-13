require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { [*('A'..'Z')].sample }
  end

  def score
    @grid = params[:grid].upcase
    @word = params[:word].upcase

    # validation of the word :
    is_english = is_english?(@word)
    is_in_grid = exist_in_grid?(@word, @grid)
    # scenarios :

    if is_in_grid == false
      @result = "Sorry but #{@word} can't be build out of
      #{@grid.chars.join(', ')}"
    elsif is_in_grid == true && is_english == false
      @result = "Sorry but #{@word} does not seem to be a valid English word"
    elsif is_in_grid && is_english
      @result = "Congratulations! #{@word} is a valid English word!"
      session[:score].nil? ? session[:score] = @word.length : session[:score] += @word.length
      @score = session[:score]
    end
  end

  def exist_in_grid?(word, grid)
    word.upcase.chars.all? { |letter| word.upcase.count(letter) <= grid.count(letter) }
  end

  def is_english?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_serialized = open(url).read
    word_check = JSON.parse(word_serialized)
    is_english = word_check['found']
  end
end
