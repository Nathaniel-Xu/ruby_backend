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
end

car = MyCar.new('2023', 'yellow', 'Lamborghini')

car.speed
car.speed_up(120)
car.speed
car.brake(100)
car.speed
car.park
car.brake(20)
car.park