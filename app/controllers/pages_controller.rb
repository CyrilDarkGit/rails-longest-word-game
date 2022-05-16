require 'open-uri'
require 'json'

class PagesController < ApplicationController
  def new
    @letters = (0...10).map { ('a'..'z').to_a[rand(26)].upcase }
  end

  def score
    result = JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{params[:guess]}/").read)
    letters = params[:letters].to_s
    check_rule = true
    params[:guess].upcase.chars.each { |letter| letters.include?(letter) ? letters[letters.index(letter)] = "0" : check_rule = false }

    if check_rule == false
      @msg = "The word can’t be built out of the original grid"
      @score = 0
    elsif result["found"] == false
      @msg =   "The word is valid according to the grid, but is not a valid English word"
      @score = 0
    else
      @msg =  "The word is valid according to the grid and is an English word"
      @score = letters.count("0")
    end
  end
end
