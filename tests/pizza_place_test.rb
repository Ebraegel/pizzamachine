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

  def test_that_sane_pizza_place_is_sane
    ["Big Dog", "Cat Soup", "Rat Friends", "Weasel Eyes", "Soda Bread"].each do |pizza_name|
      pizza = PizzaMachine::Pizza.new(name: pizza_name)
      @pizza_place.add_pizza(pizza)
      [["10", "9.99"], ["12", "13.99"]]. each do |size, price|
        pizza.add_size_option(size: size, price: price, shape: "round")
      end
    end
    assert(@pizza_place.is_sane?)
  end

  def test_that_empty_pizza_place_is_not_sane
    refute(@pizza_place.is_sane?)
  end

  def test_that_non_sane_pizza_place_is_not_sane
    pizza = PizzaMachine::Pizza.new(name: "pizza")
    pizza.add_size_option(size: "asdf", price: "one hundred", shape: "round")
    @pizza_place.add_pizza(pizza)
    refute(@pizza_place.is_sane?)
  end
end
