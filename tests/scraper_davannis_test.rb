require 'minitest/autorun'
require 'pizzamachine.rb'

class TestScraperDavannis < Minitest::Test

  @@davannis = nil

  def setup
    @@davannis = PizzaMachine::Scraper::Davannis.run if @@davannis.nil?
  end

  def test_that_davannis_has_at_least_five_pizzas
    assert(@@davannis.pizzas.length >= 5)
  end

  def test_that_each_non_gf_pizza_has_at_least_two_size_options
    @@davannis.pizzas.each do |pizza|
      next if pizza.size_options.first.gluten_free?
      assert(pizza.size_options.length >= 2)
    end
  end

  def test_that_each_size_option_has_a_valid_price
    @@davannis.pizzas.each do |pizza|
      pizza.size_options.each do |so|
        assert(so.price.match(/^\d+\.\d+$/))
      end
    end
  end

  def test_that_each_size_option_has_a_valid_size
    @@davannis.pizzas.each do |pizza|
      pizza.size_options.each do |so|
        assert(so.size.match(/^\d+$/))
      end
    end
  end

  def test_that_each_price_can_be_cast_to_float
    @@davannis.pizzas.each do |pizza|
      pizza.size_options.each do |so|
        assert(!!Float(so.price))
      end
    end
  end

  def test_that_at_least_one_pizza_has_works_in_the_name
    pass = false
    @@davannis.pizzas.each do |pizza|
      pass = true if pizza.name.downcase.match(/works/)
    end
    assert(pass)
  end
end
