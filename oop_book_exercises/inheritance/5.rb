class Vehicle
  @@num_of_vehicles = 0
  
  attr_accessor :speed, :year, :color, :model
  
  def initialize(y, c, m)
    @speed = 0
    @@num_of_vehicles += 1
    @year = y
    @color = c
    @model = m
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
  
  def age
    "Your #{self.model} is #{years_old} years old"
  end
  
  def to_s
    "Year: #{year}, Model: #{model}, Color: #{color}"
  end
  
  private
  
  def years_old
    Time.now.year - self.year
  end
  
end

module SouthernAccent
  def road_rage
    puts "Fuark you, I'm a marine with over 60 confirmed kills."
  end
end

class MyCar < Vehicle
end

class MyTruck < Vehicle
  include SouthernAccent
end

car = MyCar.new(2023, 'yellow', 'Lamborghini')

puts car