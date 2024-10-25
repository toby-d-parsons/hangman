class SecretWord
  attr_reader :WORD

  def initialize(secret_word)
    @WORD = secret_word || get_word
  end

  def get_word
    File.read("google-10000-english-no-swears.txt")
        .split
        .select { |item| (5..12).include?(item.length) }
        .sample
  end
end