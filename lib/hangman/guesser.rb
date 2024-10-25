class Guesser
  def get_guess
    guess = gets.chomp
                .downcase
    self.validate_input(guess) ? guess : (puts "Please enter a valid character or 'save' to save your progress"; get_guess)
  end

  def validate_input(input)
    (!!(input =~ /[A-Za-z]/) &&
    input.length < 2) || (input.strip
                               .downcase == 'save')
  end
end