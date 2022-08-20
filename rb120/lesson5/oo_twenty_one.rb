class Card
  attr_reader :value, :face

  def initialize(suit, face)
    @suit = suit
    @face = face
    @value = calc_value
  end

  def calc_value
    Deck::FACE_CARDS.include?(@face) ? 10 : @face.to_i
  end

  def to_s
    "#{@face} of #{@suit}"
  end
end

class Deck
  SUITS = %w(Hearts Diamonds Spades Clubs)
  FACES = %w(2 3 4 5 6 7 8 9 Jack Queen King Ace)
  FACE_CARDS = %w(Jack Queen King Ace)

  def initialize
    @cards = new_deck
  end

  def deal!
    @cards.pop
  end

  def reset!
    @cards = new_deck
  end

  private

  def new_deck
    deck = []
    SUITS.each do |suit|
      FACES.each do |face|
        deck << Card.new(suit, face)
      end
    end
    deck.shuffle!
  end
end

class Player
  attr_reader :total, :hand

  def initialize
    @hand = []
    @total = 0
  end

  def <<(card)
    @hand << card
    increment_total!
  end

  def reset!
    @hand = []
    @total = 0
  end

  def to_s
    joinand(@hand)
  end

  private

  def calc_total
    total = 0
    non_ace_cards = @hand.select { |card| card unless card.face == 'Ace' }
    aces = @hand.size - non_ace_cards.size
    non_ace_cards.each do |card|
      total += card.value
    end
    aces.times { total += total + 11 > TwentyOne::GAME_SIZE ? 1 : 11 }
    total
  end

  def increment_total!
    @total = calc_total
  end

  def joinand(arr)
    return arr.to_s if arr.size <= 1
    return arr.join(' and ') if arr.size == 2
    arr.map do |card|
      if card == arr.last
        "and #{card}"
      else
        "#{card}, "
      end
    end.join
  end
end

module Displayable
  def prompt(msg)
    puts "=> #{msg}"
  end

  def pause
    prompt "Press enter for next screen..."
    gets
    system "clear"
  end

  def display_introduction
    system 'clear'
    prompt "Welcome to Twenty_One!"
    prompt "Find the rules at: https://bargames101.com/21-card-game-rule/"
    prompt "First to #{TwentyOne::GAMES_TO_WIN} wins!"
    pause
  end

  def display_interface
    system 'clear'
    prompt "Dealer has: #{dealer.hand.first} and ?"
    prompt "You have: #{player}"
    prompt "Your total is: #{player.total}"
  end

  def hit_or_stay?(answer = nil)
    prompt "Hit or stay? (h/s)"
    loop do
      answer = gets.chomp.downcase
      break if %w(h hit s stay).include?(answer)
      prompt "Please enter hit or stay (h/s)"
    end
    answer
  end

  def display_score
    update_score
    prompt "Score: Player #{score[player]}, Dealer #{score[dealer]}"
  end

  def display_cards
    puts "=============="
    prompt "Dealer cards: #{dealer} = #{dealer.total}"
    prompt "Player cards: #{player} = #{player.total}"
    puts "=============="
  end

  def display_busted(result)
    case result
    when :player_busted
      prompt "You busted! Dealer wins."
    when :dealer_busted
      prompt "Dealer busted! You win."
    end
  end

  def display_result
    result = detect_result
    display_busted(result)
    case result
    when :player
      prompt "You win!"
    when :dealer
      prompt "Dealer wins."
    when :tie
      prompt "It's a tie!"
    end
  end

  def show_results
    display_cards
    display_result
    display_score
    display_winner if match_winner
  end

  def display_winner
    prompt "#{match_winner} reaches #{TwentyOne::GAMES_TO_WIN} points first!"
  end

  def stop_early?
    prompt "Press enter to continue or type exit to stop"
    answer = gets.chomp.downcase
    system 'clear'
    true if %w(e exit).include?(answer)
  end

  def play_again?(answer = nil)
    prompt "Play again? (y/n)"
    loop do
      answer = gets.chomp.downcase
      break if %w(y yes n no).include?(answer)
      prompt "Enter yes or no (y/n)"
    end
    true if %w(y yes).include?(answer)
  end
end

class TwentyOne
  def initialize
    display_introduction
    @player = Player.new
    @dealer = Player.new
    @deck = Deck.new
    @score = { player => 0, dealer => 0, :tie => 0 }
  end

  def play
    loop do
      main_game
      break unless play_again?
      reset_score!
    end
    prompt "Thank you for playing Twenty One! Goodbye!"
  end

  private

  attr_reader :player, :dealer, :deck, :score

  include Displayable
  GAME_SIZE = 21
  GAMES_TO_WIN = 3
  DEALER_STAY = 17

  def main_game
    loop do
      initialize_hands
      player_turn
      dealer_turn unless busted?(player)
      show_results
      reset_game!
      break if match_winner || stop_early?
    end
  end

  def initialize_hands
    2.times { player << deck.deal! }
    2.times { dealer << deck.deal! }
  end

  def busted?(player)
    player.total > GAME_SIZE
  end

  def player_turn
    loop do
      display_interface
      answer = hit_or_stay?
      if %w(h hit).include?(answer)
        player << deck.deal!
        break if busted?(player)
      elsif %w(s stay).include?(answer)
        break
      end
    end
  end

  def dealer_turn
    prompt "You stay at #{player.total}"
    prompt "Dealer Turn..."
    loop do
      break if dealer.total >= DEALER_STAY
      prompt "Dealer hits"
      dealer << deck.deal!
    end
    prompt "Dealer stays" unless busted?(dealer)
    pause
  end

  def detect_busted
    if player.total > GAME_SIZE
      :player_busted
    elsif dealer.total > GAME_SIZE
      :dealer_busted
    end
  end

  def detect_result
    return detect_busted if detect_busted
    if dealer.total < player.total
      :player
    elsif dealer.total > player.total
      :dealer
    else
      :tie
    end
  end

  def update_score
    result = detect_result
    if result == :player || result == :dealer_busted
      score[player] += 1
    elsif result == :dealer || result == :player_busted
      score[dealer] += 1
    end
  end

  def match_winner
    if score[player] >= GAMES_TO_WIN
      'Player'
    elsif score[dealer] >= GAMES_TO_WIN
      'Dealer'
    end
  end

  def reset_game!
    deck.reset!
    player.reset!
    dealer.reset!
  end

  def reset_score!
    @score = { player => 0, dealer => 0, :tie => 0 }
  end
end

TwentyOne.new.play
