require 'minitest/autorun'
require 'pizzamachine.rb'

class TestPizzaPlace < Minitest::Test
  def setup
    @pizza_place = PizzaMachine::PizzaPlace.new
  end

  def test_adding_a_pizza_to_the_pizza_place
    pizza_options = {name: "Test Pizza"}
    pizza = PizzaMachine::Pizza.new(pizza_options)
    @pizza_place.add_pizza(pizza)
    assert_instance_of(PizzaMachine::Pizza, @pizza_place.pizzas[0])
    assert_instance_of(PizzaMachine::PizzaPlace, @pizza_place.pizzas[0].pizza_place)
  end
end