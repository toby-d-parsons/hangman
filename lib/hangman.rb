require 'yaml'
require_relative './hangman/secret_word.rb'
require_relative './hangman/guesser.rb'
require_relative './hangman/board.rb'

module Hangman
  def self.run
    Dir.mkdir('./saves') unless Dir.exist?('./saves')
    puts "Welcome to Hangman! Type 'new' or 'load' to play"
    main_menu
  end

  def self.game(secret_word = nil, lives = nil, current_state = nil)
    @secret_word = SecretWord.new(secret_word)
    # puts @secret_word.WORD
    @guesser = Guesser.new()
    @board = Board.new(@secret_word.WORD, lives, current_state)
    sleep(0.5)
    @board.display_board
    take_turn
  end

  def self.main_menu
    selection = gets.chomp
                    .downcase
    if selection == 'load'
      puts "Game loaded"
      load_game
    elsif selection == 'new'
      puts "A random word has been chosen for you to guess. Enter single letters to uncover the mystery word, but be careful — you only have a few guesses!"
      game
    else
      puts "Invalid entry, please select 'new' or 'load' to play"
      main_menu
    end
  end
  
  def self.take_turn
    puts "Type 'save' to save your progress"
    guess = @guesser.get_guess
    if guess == 'save'
      save_game
      return
    else
      @board.letter_in_word?(guess) || @board.lives -=1
    end
    if @board.game_state == 'win'
      puts "You win! The word was '#{@secret_word.WORD}'"
      return
    elsif @board.game_state == 'lose'
      puts "You lose! The word was '#{@secret_word.WORD}'"
      return
    end
    @board.display_board
    take_turn
  end

  def self.save_game
    if overwrite_or_new_save? == 'overwrite'
      if Dir.glob("./saves/*.yaml").length > 0
        uuid = select_save('saving')
        write_to_file(uuid)
        puts "Save #{uuid} overwritten"
      else
        puts "No save files available!"
        puts "Saving a new file..."
        write_to_file(get_file_name)
      end
    else
      puts "Saving a new file..."
      write_to_file(get_file_name)
    end
    puts "Your progress has been saved"
  end

  def self.overwrite_or_new_save?
    puts "Save game: new or overwrite?"
    input = gets.chomp.downcase
    if input == 'new' || input == 'overwrite'
      input
    else
      puts "Invalid entry"
      overwrite_or_new_save?
    end
  end

  def self.overwrite_save
    write_to_file(select_save('saving'))
  end

  def self.select_save(action)
    puts "Select a save to overwrite" if action == 'saving'
    puts "Select a save to load" if action == 'loading'
    file_name_uuid.each { |element| puts element }
    input = gets.chomp
    if file_name_uuid.any? { |element| element == input }
      input.to_s
    else
      puts "Invalid entry"
      select_save(action)
    end
  end

  def self.load_game
    if Dir.glob("./saves/*.yaml").length > 0
      uuid = select_save('loading')
      data = YAML.load File.read("./saves/save#{uuid}.yaml")
      puts "Save #{uuid} loaded"
      game(data[:secret_word], data[:lives], data[:current_state])
    else
      puts "No save files available!"
      sleep(0.5)
      puts "Starting a new game..."
      puts "A random word has been chosen for you to guess. Enter single letters to uncover the mystery word, but be careful — you only have a few guesses!"
      game
    end
  end

  def self.to_yaml
    YAML.dump ({
      :secret_word => @secret_word.WORD,
      :lives => @board.lives,
      :current_state => @board.current_state
    })
  end

  def self.write_to_file(file_name)
    File.open("./saves/save#{file_name}.yaml", 'w') do |file|
      file.puts to_yaml
    end
  end

  def self.get_file_name
    arr = [00]
    arr += Dir.glob("./saves/*.yaml")
              .map { |file| File.basename(file).tr("^0-9","").to_i}
    sprintf('%02d', (arr.sort[-1] + 1))
  end

  def self.file_name_uuid
    Dir.glob("./saves/*.yaml").map { |file| File.basename(file).tr("^0-9","").to_i}
                                    .map { |num| sprintf('%02d', num)}
  end
end

app = Hangman
app.run