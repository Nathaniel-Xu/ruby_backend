class Player
  attr_accessor :move, :name, :score

  def initialize
    set_name
    @score = 0
  end

  def assign_value(choice)
    @move = case choice
            when 'Rock'     then Rock.new
            when 'Paper'    then Paper.new
            when 'Scissors' then Scissors.new
            when 'Lizard'   then Lizard.new
            when 'Spock'    then Spock.new
            end
  end
end

class Human < Player
  def set_name
    print "Choose a name: "
    @name = gets.chomp
  end

  def choose
    choice = nil
    loop do
      puts "Please choose one of #{Move::VALUES.join(' ')}:"
      choice = gets.chomp.capitalize
      break if Move::VALUES.include?(choice)
      puts "Sorry, invalid choice."
    end
    assign_value(choice)
  end
end

class Computer < Player
  def set_name
    puts "Who do you want to face? (AlphaZero/Komodo):"
    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if %w(a k alphazero komodo).include?(answer)
      puts "Sorry, please type either AlphaZero or Komodo (a/k):"
    end
    @name = 'AlphaZero' if answer == 'alphazero'
    @name = 'Komodo' if answer == 'komodo'
    system 'clear'
  end

  def choose
    alphazero_ai if @name == 'AlphaZero'
    komodo_ai if @name == 'Komodo'
  end
  
  def alphazero_ai
    assign_value(['Spock', 'Spock', 'Spock', 'Rock', 'Paper', 'Scissors'].sample)
  end
  
  def komodo_ai
    assign_value(['Lizard'].sample)
  end
end

class Move
  attr_accessor :value

  VALUES = %w(Rock Paper Scissors Lizard Spock)
  def to_s
    @value
  end
end

class Rock < Move
  def initialize
    @value = 'Rock'
  end

  def >(other_move)
    other_move.value == 'Scissors' || other_move.value == 'Lizard'
  end
end

class Paper < Move
  def initialize
    @value = 'Paper'
  end

  def >(other_move)
    other_move.value == 'Rock' || other_move.value == 'Spock'
  end
end

class Spock < Move
  def initialize
    @value = 'Spock'
  end

  def >(other_move)
    other_move.value == 'Rock' || other_move.value == 'Scissors'
  end
end

class Lizard < Move
  def initialize
    @value = 'Lizard'
  end

  def >(other_move)
    other_move.value == 'Paper' || other_move.value == 'Spock'
  end
end

class Scissors < Move
  def initialize
    @value = 'Scissors'
  end

  def >(other_move)
    other_move.value == 'Paper' || other_move.value == 'Lizard'
  end
end

class RPSGame
  attr_accessor :human, :comp

  GAMES_TO_WIN = 5
  def initialize
    display_welcome_message
    @human = Human.new
    @comp = Computer.new
    @move_history = []
  end

  def display_welcome_message
    system 'clear'
    puts "Welcome to #{Move::VALUES.join(' ')}!"
    puts "First to 5 wins!"
  end

  def display_choices
    puts "#{human.name} chose #{human.move}"
    puts "#{comp.name} chose #{comp.move}"
  end

  def update_score
    result = detect_result
    case result
    when :human then human.score += 1
    when :comp  then comp.score += 1
    end
  end

  def display_score
    update_score
    puts "Score: #{human.name} #{human.score}, #{comp.name} #{comp.score}"
    puts "#{match_winner} reached #{GAMES_TO_WIN} wins first!" if match_winner
    @move_history << [human.move, comp.move]
  end

  def detect_result
    if human.move > comp.move
      :human
    elsif comp.move > human.move
      :comp
    else
      :tie
    end
  end

  def display_result
    result = detect_result
    case result
    when :human then puts "#{human.name} won!"
    when :comp  then puts "#{comp.name} won!"
    when :tie   then puts "It's a tie!"
    end
  end

  def result_screen
    system 'clear'
    display_choices
    display_result
    display_score
  end

  def stop_early?
    answer = nil
    loop do
      puts "Press enter to continue or type exit to stop"
      answer = gets.chomp.downcase
      break if ['', 'e', 'exit'].include?(answer)
    end
    system 'clear'
    %w(e exit).include?(answer)
  end

  def match_winner
    if human.score >= GAMES_TO_WIN
      human.name
    elsif comp.score >= GAMES_TO_WIN
      comp.name
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Play again? (y/n)"
      answer = gets.chomp.downcase
      break if %w(y n).include?(answer)
      puts "Please enter y or n."
    end
    answer == 'y' ? true : puts("Thanks for playing Rock, Paper, Scissors!")
  end

  def reset_score
    human.score = 0
    comp.score = 0
    system 'clear'
  end

  def one_turn
    human.choose
    comp.choose
    result_screen
  end

  def display_moves
    puts "  #{human.name}  #{comp.name}"
    @move_history.each do |arr|
      puts "#{arr.first}   #{arr.last}".center(20)
    end
  end

  def play
    loop do
      loop do
        one_turn
        break if match_winner
        break if stop_early?
      end
      break unless play_again?
      reset_score
    end
    display_moves
  end
end

RPSGame.new.play
