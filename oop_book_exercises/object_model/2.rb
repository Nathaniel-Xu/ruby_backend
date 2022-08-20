=begin
A module is a group of methods.
It allows code to be reused in and abstracted from classes
=end

module Pi
  def pi
    3.14159265358979323846264338
  end
end

class MyClass
  include Pi
end

my_obj = MyClass.new

p my_obj.pi