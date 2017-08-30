require 'minitest/autorun'
require 'pizzamachine.rb'

class TestPizza < Minitest::Test
  def setup
    @pizza_options = {name: "Test Pizza", pizza_place: "The Test Pizza Shop"}
    @pizza = PizzaMachine::Pizza.new(@pizza_options)
  end

  def test_initializing_a_pizza
    assert_equal(@pizza_options[:name], @pizza.name)
    assert_equal(@pizza_options[:pizza_place], @pizza.pizza_place)
  end

  def test_adding_an_instance_of_size_option
    size_option_options = {size: 16, price: 19.95, shape: "round"}
    size_option = PizzaMachine::SizeOption.new(size_option_options)
    @pizza.add_size_option(size_option)
    so = @pizza.size_options[0]
    assert_instance_of(PizzaMachine::SizeOption, so)
    assert_equal(size_option_options[:size], so.size)
    assert_equal(size_option_options[:price], so.price)
    assert_equal(size_option_options[:shape], so.shape)
  end

  def test_adding_a_size_option_by_param_hash
    size_option_options = {size: 18, price: 23.50, shape: "square"}
    @pizza.add_size_option(size_option_options)
    so = @pizza.size_options[0]
    assert_instance_of(PizzaMachine::SizeOption, so)
    assert_equal(size_option_options[:size], so.size)
    assert_equal(size_option_options[:price], so.price)
    assert_equal(size_option_options[:shape], so.shape)
  end

  def test_adding_a_pizza_place_to_the_pizza
    pizza_place_options = {name: "Test Pizza Place"}
    pizza_place = PizzaMachine::PizzaPlace.new(pizza_place_options)
    @pizza.add_to_pizza_place(pizza_place)
    assert_instance_of(PizzaMachine::Pizza, pizza_place.pizzas[0])
    assert_instance_of(PizzaMachine::PizzaPlace, @pizza.pizza_place)
  end
end
