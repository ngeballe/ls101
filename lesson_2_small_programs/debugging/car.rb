require 'pry'

class Car
  attr_accessor :brand, :model

  def initialize(new_car)
    brand = new_car.split(' ').first
    model = new_car.split(' ').last
    binding.pry
  end

end

betty = Car.new('Ford Mustang')
p betty
puts betty.brand
puts betty.model
betty.model.start_with?('M')
# puts betty.model.start_with?('M')  # => NoMethodError: undefined method `start_with?' for nil:NilClass
