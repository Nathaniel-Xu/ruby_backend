class Person
  attr_accessor :first_name, :last_name
  def initialize(full_name)
    parts = full_name.split
    @first_name = parts.first
    @last_name = parts.size > 1 ? parts.last : ''
  end
  
  def name
    @first_name + ' ' + @last_name
  end
  
  def name=(full_name)
    parts = full_name.split
    @first_name = parts.first
    @last_name = parts.size > 1 ? parts.last : ''
  end
  
  def ==(other_person)
    self.name == other_person.name
  end
  
  def to_s
    name
  end
end

bob = Person.new("Robert Smith")
puts "The person's name is: #{bob}"

