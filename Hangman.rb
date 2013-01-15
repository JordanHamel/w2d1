class Hangman
  attr_reader :board, :past_guesses
  MAX_GUESSES = 10

  def initialize
    @board = []
  end

  def play
    setup_game

    guess_num = 0
    @past_guesses = []

    while guess_num <= MAX_GUESSES
      break if game_won?
      print_board
      guess = get_guess(MAX_GUESSES - guess_num)

      if guess.length > 1
        won = @responder.won?(guess)
        break
      else
        indices = @responder.get_indices(guess)
        populate_board(guess, indices)
      end
      guess_num += 1
      @past_guesses << guess
    end

    if won == false
      puts "That is not the word. You lose!"
    elsif guess_num <= MAX_GUESSES
      puts "You won in #{guess_num} tries!"
    else
      puts "You have run out of turns!"
    end
  end

  def get_guess(guesses_left)
    while true
      guess = @guesser.get_guess(guesses_left)
      return guess if valid_guess?(guess)
      puts "Invalid guess. Guess again."
    end
  end

  def valid_guess?(guess)
    return true if guess.length == @board.length
    return false unless guess.length == 1 && ('a'..'z').include?(guess)
    return false if @past_guesses.include?(guess)
    true
  end

  def setup_game
    @guesser, @responder = choose_mode
    word_length = @responder.word_length
    @board = ['_'] * word_length
  end

  def choose_mode
    print "Would you like to guess the computer's word (y/n)? "
    case gets.chomp.downcase[0]
    when "y"
      return [HumanPlayer.new(self), ComputerPlayer.new(self)]
    when "n"
      return [ComputerPlayer.new(self), HumanPlayer.new(self)]
    else
      puts "enter \"y\" or \"n\""
      choose_mode
    end
  end


  def game_won?
    !@board.include?('_')
  end

  def print_board
    puts "#{@board.join(' ')}"
  end

  def populate_board(guess, indices)
    indices.each { |i| @board[i] = guess }
  end
end

class HumanPlayer
  def initialize(game)
    @game = game
  end

  def get_guess(guesses_left)
    puts "Guess a letter. You have #{guesses_left} guesses left!"
    gets.chomp.downcase
  end

  def word_length
    puts "Pick a word from dictionary.txt"
    print "How long is the word you chose? "
    gets.chomp.to_i
  end

  def get_indices(guess)
    indices = []
    print "Is #{guess} in your word (y/n)? "
    case gets.chomp.downcase[0]
    when 'y'
      puts "#{@game.print_board}"
      puts "#{(1..@game.board.length).to_a.join(" ")}"
      print "At what positions is #{guess} in your word (ex. '1, 2, 3')? "
      indices += gets.chomp.split(", ").map { |num| num.to_i - 1 }
    end
    indices
  end

  def won?(guess)
    print "Is the word #{guess} (y/n)? "
    case gets.chomp.downcase[0]
    when 'y'
      return true
    when 'n'
      return false
    else
      puts "Please enter y or n"
      won?(guess)
    end
  end
end

class ComputerPlayer
  def initialize(game)
    @dictionary = File.readlines("dictionary.txt").map(&:chomp)
    @game = game
  end

  def get_guess(guesses_left)
    filter_dictionary
    if @dictionary.length == 1
      guess = @dictionary[0]
    else
      guess = most_frequent_letter
    end
  end

  def filter_dictionary
    if @game.past_guesses.length == 0
      @dictionary.select! { |word| word.length == @game.board.length }
    else
      @dictionary = @dictionary.select do |word|
        match = true
        @game.board.each_with_index do |letter, index|
          unless letter == '_'
            match = false if word[index] != letter
          end
        end
        match
      end
    end
  end

  def most_frequent_letter
    frequency = Hash.new(0)
    @dictionary.each do |word|
      word.each_char { |letter| frequency[letter] += 1 }
    end
    @game.past_guesses.each { |guess| frequency.delete(guess) }
    frequency.each { |k, v| return k if v == frequency.values.max }
  end

  def word_length
    @word = @dictionary.sample
    p @word
    @word.length
  end

  def get_indices(guess)
    indices = []
    @word.split('').each_with_index do |letter, i|
      indices << i if guess == letter
    end
    indices
  end

  def won?(guess)
    @word == guess ? true : false
  end
end

game = Hangman.new
game.play