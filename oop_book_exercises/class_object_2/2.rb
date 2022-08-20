class MyCar
  attr_accessor :speed, :year, :color, :model
  
  def initialize(y, c, m)
    @year = y
    @color = c
    @model = m
    @speed = 0
  end
  
  def speed_up(num)
    @speed += num
  end
  
  def brake(num)
    @speed -= num
  end
  
  def park
    if @speed != 0
      puts "You crashed and died!"
    else
      puts "Nice parking!"
    end
  end
  
  def speed
    puts "You are going #{@speed} miles per hour"
  end
  
  def self.gas_mileage(gallons, miles)
    puts "#{miles / gallons} miles per gallon of gas"
  end
  
  def to_s
    "Year: #{year}, Model: #{model}, Color: #{color}"
  end
end

car = MyCar.new('2023', 'yellow', 'Lamborghini')

puts car