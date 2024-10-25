class Board
  attr_accessor :lives, :current_state

  def initialize(word, lives, current_state)
    @secret_word = word
    @lives = lives || 6
    @current_state = current_state || @secret_word.split("")
                                                  .map { |item| '_ '}
  end

  def display_board
    word_length = @secret_word.length
    puts @current_state.join()
                       .strip + " (#{word_length})"
    @lives != 1 ? (puts "#{@lives} lives remaining") : (puts "#{@lives} life remaining")
  end

  def letter_in_word?(guess)
    @secret_word.split("")
                .each_with_index do |element, index|
      @current_state[index] = "#{guess} " if element == guess
    end
    @secret_word.split("")
                .include?(guess)
  end

  def game_state
    if @current_state.all? { |element| element.match?(/[A-Za-z]/)}
      'win'
    elsif @lives == 0
      'lose'
    end
  end
end