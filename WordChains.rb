# Ryan S and Kriti
# W2D1

class WordNode
  attr_reader :value, :parent

  def initialize(value, parent)
    @value, @parent = value, parent
  end
end

class WordChain
  def initialize(start_word, end_word)
    @start_word, @end_word = start_word, end_word
    @dictionary = File.readlines('dictionary.txt').map(&:chomp)

    if !words_in_dictionary?
      raise ArgumentError, "Use words in dictionary.txt"
    elsif @start_word.length != @end_word.length
      raise ArgumentError, "Please use words of the same length"
    end
  end

  def find_path
    queue = [WordNode.new(@start_word, nil)]
    initial_dictionary_filter

    # Assigns word to be the first word in queue.
    # If queue is empty, returns nil and breaks loop.
    while word = queue.shift
      break if word.value == @end_word
      children = find_children(word)

      # Removes children from dictionary so that no word is checked
      # again in a succeeding breadth.
      filter_dictionary(children)

      queue += children
    end

    word.nil? ? puts("No path found.") : print_path(word)
  end

  private

  def print_path(word)
    print_path(word.parent) unless word.parent.nil?
    puts word.value
  end

  # Find words one letter away in the dictionary
  def find_children(word)
    children = []
    @dictionary.each do |child|
      matches = 0
      child.length.times do |index|
        matches += 1 if child[index] == word.value[index]
      end
      children << WordNode.new(child, word) if matches == (child.length - 1)
    end
    children
  end

  #Yesterday, Ned was talking to us about how if you have to do something once
  #before a loop, and then continue doing it during the loop, there might 
  #be a way to combine them. Not sure if that applies here, but it's something
  #to think about
  # Initial filter by word length and remove start_word
  def initial_dictionary_filter
    @dictionary.delete(@start_word)
    @dictionary.select! { |word| word.length == @start_word.length }
  end

  # Removes words from dictionary
  def filter_dictionary(words)
    words.each { |word| @dictionary.delete(word.value) }
  end

  def words_in_dictionary?
    @dictionary.include?(@start_word) && @dictionary.include?(@end_word)
  end
end

chain = WordChain.new(*ARGV)
chain.find_path