class Hangman
  def initialize
    @board = []
    MAX_GUESSES = 10
  end

  def play
    setup_game

    guess_num = 1
    past_guesses = []

    while guess_num <= MAX_GUESSES
      break if game_won?
      print_board
      guess = get_guess(past_guesses)
      indices = @responder.get_indices(guess)

      populate_board(guess, indices)

      guess_num += 1
      past_guesses << guess
    end
  end

  def get_guess(past_guesses)
    while true
      guess = @player.get_guess
      return guess if valid_guess?(guess)
      puts "Invalid guess. Guess again."
    end
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
      return [HumanPlayer.new, ComputerPlayer.new]
    when "n"
      return [ComputerPlayer.new, HumanPlayer.new]
    else
      puts "enter \"y\" or \"n\""
      choose_mode
    end
  end

  def game_won?
    !@board.include?('_')
  end

  def print_board
    puts "Your board: #{@board.join(' ')}"
  end

  def populate_board(guess, indices)
    indices.each { |i| @board[i] = guess }
  end
end

class HumanPlayer
  def get_guess
  end

  def word_length
  end

  def get_indices
  end
end

class ComputerPlayer
  def get_guess
  end

  def word_length
  end

  def get_indices
  end
end

game = Hangman.new
game.play