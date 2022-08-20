class Board
  INITIAL_MARKER = ' '

  def initialize
    @squares = Array.new(10) { INITIAL_MARKER }
  end

  def [](key)
    @squares[key]
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def display
    system 'clear'
    puts ''
    puts '     |     |'
    puts "  #{self[1]}  |  #{self[2]}  |  #{self[3]}"
    puts '     |     |'
    puts '-----+-----+-----'
    puts '     |     |'
    puts "  #{self[4]}  |  #{self[5]}  |  #{self[6]}"
    puts '     |     |'
    puts '-----+-----+-----'
    puts '     |     |'
    puts "  #{self[7]}  |  #{self[8]}  |  #{self[9]}"
    puts '     |     |'
    puts ''
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def []=(key, marker)
    @squares[key] = marker
  end

  def empty_squares
    (1..9).select { |number| @squares[number] == INITIAL_MARKER }
  end

  def reset
    @squares = Array.new(10) { INITIAL_MARKER }
  end
end

module Blockable
  def block_human_threat(board)
    TTTGame::WINNING_LINES.each do |arr|
      line = arr.map { |idx| board[idx] }
      if line.count(Board::INITIAL_MARKER) == 1 && !(line.include?(marker))
        return arr[line.index(Board::INITIAL_MARKER)]
      end
    end
    nil
  end
end

module Proactive
  def winning_move(board)
    TTTGame::WINNING_LINES.each do |arr|
      line = arr.map { |idx| board[idx] }
      if line.count(marker) == 2 && line.include?(Board::INITIAL_MARKER)
        return arr[line.index(Board::INITIAL_MARKER)]
      end
    end
    nil
  end

  def detect_comp_threats(board)
    result = []
    TTTGame::WINNING_LINES.each do |arr|
      line = arr.map { |idx| board[idx] }
      if line.count(Board::INITIAL_MARKER) == 2 && line.include?(marker)
        result << arr.select.with_index do |key, idx|
          key if line[idx] == Board::INITIAL_MARKER
        end
      end
    end
    result.flatten.uniq
  end

  def create_threat(board)
    threats = detect_comp_threats(board)
    return nil if threats.empty?
    threats.each { |num| return num if empty_corners(board).include?(num) }
    threats.sample
  end

  def open_middle?(board)
    board[5] == Board::INITIAL_MARKER
  end

  def empty_corners(board)
    empty_squares = board.empty_squares
    [1, 3, 7, 9].select { |num| empty_squares.include?(num) }
  end

  def empty_space(board)
    return empty_corners(board).sample unless empty_corners(board).empty?
    board.empty_squares.sample
  end

  def forced_move(board)
    return winning_move(board) if winning_move(board)
    block_human_threat(board)
  end
end

class Player
  attr_reader :marker

  def initialize
    @name = set_name
    @marker = set_marker
  end

  def move(board)
    board[generate_move(board)] = @marker
  end

  def to_s
    @name
  end
end

class Human < Player
  private

  def set_name
    print 'What is your name?: '
    answer = nil
    loop do
      answer = gets.chomp.strip
      break unless answer.empty?
      print 'Please enter a name: '
    end
    answer
  end

  def set_marker
    print 'What single character marker do you want?: '
    answer = nil
    loop do
      answer = gets.chomp.strip
      break if answer.length == 1
      print 'Please enter a single character: '
    end
    answer
  end

  def generate_move(board)
    print "Select a square (#{board.empty_squares.join('/')}): "
    answer = nil
    loop do
      answer = gets.chomp.to_i
      break if board.empty_squares.include?(answer)
      print "Please select a valid square(#{board.empty_squares.join('/')}): "
    end
    answer
  end
end

class AlphaZero < Player
  def initialize
    @name = 'AlphaZero'
    @marker = 'A'
  end

  private

  include Proactive, Blockable

  def generate_move(board)
    return forced_move(board) if forced_move(board)
    return 5 if open_middle?(board)
    return create_threat(board) if create_threat(board)
    empty_space(board)
  end
end

class Komodo < Player
  def initialize
    @name = 'Komodo'
    @marker = 'K'
  end

  private

  include Blockable

  def generate_move(board)
    return block_human_threat(board) if block_human_threat(board)
    board.empty_squares.sample
  end
end

class Stockfish < Player
  def initialize
    @name = 'Stockfish'
    @marker = 'S'
  end

  def generate_move(board)
    board.empty_squares.sample
  end
end

class TTTGame
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                  [[1, 5, 9], [3, 5, 7]]

  def initialize
    start_screen
    @board = Board.new
    @human = Human.new
    @comp = computer
    @score = { human => 0, comp => 0, :tie => 0 }
  end

  def play
    loop do
      loop do
        alternate_turns
        end_screen
        break if match_winner || stop_early?
      end
      break unless play_again?
      reset_score
    end
    goodbye_message
  end

  private

  attr_reader :board, :human, :comp

  POINTS_TO_WIN = 3

  def computer(answer = nil)
    puts 'AlphaZero: Hard | Komodo: Medium | Stockfish: Easy'
    print 'Would you like to face: AlphaZero, Komodo, or Stockfish? (a/k/s): '
    loop do
      answer = convert_ans(gets.chomp.downcase)
      break if %w(AlphaZero Komodo Stockfish).include?(answer.to_s)
      print "Please type a, k, or s: "
    end
    confirm_name(answer)
    answer
  end

  def convert_ans(answer)
    case answer
    when 'a' then AlphaZero.new
    when 'k' then Komodo.new
    when 's' then Stockfish.new
    end
  end

  def confirm_name(name)
    puts "Alright, you'll face #{name}!"
    print "Press enter to continue..."
    gets
  end

  def start_screen
    system 'clear'
    puts "Welcome to Tic Tac Toe!"
    puts "It's a best of 5!"
    puts "The squares are represented by numbers 1-9"
  end

  def go_first?
    print "Go first? (y/n): "
    answer = nil
    loop do
      answer = gets.chomp.downcase
      break if %w(y n).include?(answer)
      puts "Please enter y or n: "
    end
    board.display
    answer == 'y' ? human : comp
  end

  def who_won?
    WINNING_LINES.each do |arr|
      line = arr.map { |idx| board[idx] }
      return human if line.all?(human.marker)
      return comp if line.all?(comp.marker)
    end
    nil
  end

  def full?
    board.empty_squares.empty?
  end

  def switch_player(player)
    player == human ? comp : human
  end

  def alternate_turns
    board.display
    player = go_first?
    loop do
      player.move(board)
      board.display
      break if who_won? || full?
      player = switch_player(player)
    end
  end

  def update_score(winner)
    if winner == human
      @score[human] += 1
    elsif winner == comp
      @score[comp] += 1
    else
      @score[:tie] += 1
    end
  end

  def display_score(winner)
    update_score(winner)
    puts "#{human}: #{@score[human]} | #{comp}: #{@score[comp]} | \
Tie: #{@score[:tie]}"
  end

  def match_winner
    return human if @score[human] >= POINTS_TO_WIN
    comp if @score[comp] >= POINTS_TO_WIN
  end

  def display_match_winner
    puts "#{match_winner} won the match!"
  end

  def end_screen
    winner = who_won?
    if winner
      puts "#{winner} won this round!"
    else
      puts "It's a tie!"
    end
    display_score(winner)
    display_match_winner if match_winner
    board.reset
  end

  def stop_early?(answer = nil)
    print "Stop early? (y/n): "
    loop do
      answer = gets.chomp.downcase
      break if %w(y yes n no).include?(answer)
      print "Please enter yes or no (y/n): "
    end
    true if %w(y yes).include?(answer)
  end

  def play_again?(answer = nil)
    print "Play again? (y/n): "
    loop do
      answer = gets.chomp.downcase
      break if %w(y yes n no).include?(answer)
      print "Please enter yes or no (y/n): "
    end
    true if %w(y yes).include?(answer)
  end

  def reset_score
    @score = { human => 0, comp => 0, :tie => 0 }
  end

  def goodbye_message
    puts "Thanks for playing Tic Tac Toe!"
  end
end

game = TTTGame.new
game.play
