class WordGuesserGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.
  attr_accessor :word, :guesses, :wrong_guesses

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ""
    @wrong_guesses = ""
    @masked_word = "-" * word.length
  end

  def guess(letter)
    raise ArgumentError if letter.nil? || letter.empty? || !letter.match(/[a-z]/i)

    letter.downcase!

    if @guesses.include?(letter) || @wrong_guesses.include?(letter)
      return false
    end

    if @word.include?(letter)
      @guesses << letter
    else
      @wrong_guesses << letter
    end
    
    masked = (0 ... @word.length).find_all { |i| @word[i] == letter }
    masked.each { |i| @masked_word[i] = letter}

    return true
  end

  def word_with_guesses()
    @masked_word
  end

  def check_win_or_lose()
    if @word == @masked_word
      return :win
    end

    if @wrong_guesses.length >= 7
      return :lose
    end

    return :play
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end

end
