class Vehicle
  attr_accessor :speed
  def initialize
    @speed = 0
  end
  
  def speed_up(num)
    @speed += num
    puts "You are now going #{@speed} miles per hour"
  end
  
  def brake(num)
    @speed -= num
    puts "You are now going #{@speed} miles per hour"
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
end

class MyCar < Vehicle
  attr_accessor :year, :color, :model
  
  def initialize(y, c, m)
    super()
    @year = y
    @color = c
    @model = m
  end
  
  def to_s
    "Year: #{year}, Model: #{model}, Color: #{color}"
  end
end

class MyTruck < Vehicle
  attr_accessor :year, :color, :model
  
  def initialize(y, c, m)
    super()
    @year = y
    @color = c
    @model = m
    @carrying_capacity = 0
  end
  
  def to_s
    "Year: #{year}, Model: #{model}, Color: #{color}"
  end
end

car = MyCar.new('2023', 'yellow', 'Lamborghini')

car.speed()
car.speed_up(10)