class Student
  attr_reader :name
  def initialize(n, g)
    @name = n
    @grade = g
  end
  
  def better_grade_than?(other_person)
    self.grade > other_person.grade  
  end
  
  protected
  
  attr_reader :grade
end

joe = Student.new('Jonathan Marcamaius', 100)
bob = Student.new('Violet Turstoff', 10)

puts "Well done!" if joe.better_grade_than?(bob)