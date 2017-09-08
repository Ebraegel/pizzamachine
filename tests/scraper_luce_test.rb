require 'minitest/autorun'
require 'pizzamachine.rb'

class TestScraperLuce < Minitest::Test

  @@luce = nil

  def setup
    @@luce = PizzaMachine::Scraper::Luce.run if @@luce.nil?
  end

  def test_that_luce_has_at_least_five_pizzas
    assert(@@luce.pizzas.length >= 5)
  end

  def test_that_each_pizza_has_at_least_one_size_options
    @@luce.pizzas.each do |pizza|
      assert(pizza.size_options.length >= 1)
    end
  end

  def test_that_each_size_option_has_a_valid_price
    @@luce.pizzas.each do |pizza|
      pizza.size_options.each do |so|
        assert(so.price.match(/^\d+\.\d+$/))
      end
    end
  end

  def test_that_each_size_option_has_a_valid_size
    @@luce.pizzas.each do |pizza|
      pizza.size_options.each do |so|
        assert(so.size.match(/^\d+$/))
      end
    end
  end

  def test_that_each_price_can_be_cast_to_float
    @@luce.pizzas.each do |pizza|
      pizza.size_options.each do |so|
        assert(!!Float(so.price))
      end
    end
  end

  def test_that_at_least_one_pizza_has_luce_in_the_name
    pass = false
    @@luce.pizzas.each do |pizza|
      pass = true if pizza.name.downcase.match(/luce/)
    end
    assert(pass)
  end
end
