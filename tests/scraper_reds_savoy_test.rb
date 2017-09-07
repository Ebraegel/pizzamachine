require 'minitest/autorun'
require 'pizzamachine.rb'

class TestScraperRedsSavoy < Minitest::Test

  @@reds_savoy = nil

  def setup
    @@reds_savoy = PizzaMachine::Scraper::RedsSavoy.run if @@reds_savoy.nil?
  end

  def test_that_reds_savoy_has_at_least_five_pizzas
    assert(@@reds_savoy.pizzas.length >= 5)
  end

  def test_that_each_pizza_has_at_least_two_size_options
    @@reds_savoy.pizzas.each do |pizza|
      assert(pizza.size_options.length >= 2)
    end
  end

  def test_that_each_size_option_has_a_valid_price
    @@reds_savoy.pizzas.each do |pizza|
      pizza.size_options.each do |so|
        assert(so.price.match(/^\d+\.\d+$/))
      end
    end
  end

  def test_that_each_size_option_has_a_valid_size
    @@reds_savoy.pizzas.each do |pizza|
      pizza.size_options.each do |so|
        assert(so.size.match(/^\d+$/))
      end
    end
  end

  def test_that_each_price_can_be_cast_to_float
    @@reds_savoy.pizzas.each do |pizza|
      pizza.size_options.each do |so|
        assert(!!Float(so.price))
      end
    end
  end

  def test_that_at_least_one_pizza_has_savoy_in_the_name
    pass = false
    @@reds_savoy.pizzas.each do |pizza|
      pass = true if pizza.name.downcase.match(/savoy/)
    end
    assert(pass)
  end
end
