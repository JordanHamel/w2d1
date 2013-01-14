class WordNode
  attr_reader :value, :parent

  def initialize(value, parent)
    @value, @parent = value, parent
  end
end

class WordChain

  def initialize(start_word, end_word)
    @start_word, @end_word = start_word, end_word
    @dictionary = build_dictionary
  end

  def find_path
    queue = [WordNode.new(@start_word, nil)]

    while word = queue.shift
      break if word.value == @end_word
      children = find_children(word)
      filter_dictionary(children)
      queue += children
    end

    word.value == @end_word ? print_path(word) : puts("No path found.")
  end

  def print_path(word)
    print_path(word.parent) unless word.parent.nil?
    puts word.value
  end

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

  def build_dictionary
    dictionary = File.readlines('dictionary.txt').map(&:chomp)
    dictionary = dictionary.select { |word| word.length == @start_word.length }
    dictionary.delete(@start_word)
    dictionary
  end

  def filter_dictionary(words)
    words.each { |word| @dictionary.delete(word.value) }
  end
end

chain = WordChain.new(*ARGV)
chain.find_path