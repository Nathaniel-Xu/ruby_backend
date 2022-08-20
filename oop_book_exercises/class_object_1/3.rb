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
  
  def spray_paint(color)
    self.color = color
    puts "Your car is now a beautiful #{color} color!"
  end
end

car = MyCar.new('2023', 'yellow', 'Lamborghini')

p car.color
car.spray_paint('black')