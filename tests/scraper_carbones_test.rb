require 'minitest/autorun'
require 'pizzamachine.rb'

class TestScraperCarbones < Minitest::Test

  @@carbones = nil

  def setup
    @@carbones = PizzaMachine::Scraper::Carbones.run if @@carbones.nil?
  end

  def test_that_carbones_has_at_least_five_pizzas
    assert(@@carbones.pizzas.length >= 5)
  end

  def test_that_each_non_gf_pizza_has_at_least_two_size_options
    @@carbones.pizzas.each do |pizza|
      next if pizza.size_options.first.gluten_free?
      assert(pizza.size_options.length >= 2)
    end
  end

  def test_that_each_size_option_has_a_valid_price
    @@carbones.pizzas.each do |pizza|
      pizza.size_options.each do |so|
        assert(so.price.match(/^\d+\.\d+$/))
      end
    end
  end

  def test_that_each_size_option_has_a_valid_size
    @@carbones.pizzas.each do |pizza|
      pizza.size_options.each do |so|
        assert(so.size.match(/^\d+$/))
      end
    end
  end

  def test_that_each_price_can_be_cast_to_float
    @@carbones.pizzas.each do |pizza|
      pizza.size_options.each do |so|
        assert(!!Float(so.price))
      end
    end
  end

  def test_that_at_least_one_pizza_has_special_in_the_name
    pass = false
    @@carbones.pizzas.each do |pizza|
      pass = true if pizza.name.downcase.match(/special/)
    end
    assert(pass)
  end
end
