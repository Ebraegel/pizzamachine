require 'minitest/autorun'
require 'pizzamachine.rb'

class TestScraperParkway < Minitest::Test

  @@parkway = nil

  def setup
    @@parkway = PizzaMachine::Scraper::Parkway.run if @@parkway.nil?
  end

  def test_that_parkway_has_at_least_one_pizza
    assert(@@parkway.pizzas.length >= 1)
  end

  def test_that_each_pizza_has_at_least_two_size_options
    @@parkway.pizzas.each do |pizza|
      assert(pizza.size_options.length >= 2 )
    end
  end

  def test_that_each_size_option_has_a_valid_price
    @@parkway.pizzas.each do |pizza|
      pizza.size_options.each do |so|
        assert(so.price.match(/\d+\.\d+/))
      end
    end
  end

  def test_that_each_price_can_be_cast_to_float
    @@parkway.pizzas.each do |pizza|
      pizza.size_options.each do |so|
        assert(so.price.respond_to?(:to_f))
      end
    end
  end

  def test_that_each_size_option_has_a_valid_size
    @@parkway.pizzas.each do |pizza|
      pizza.size_options.each do |so|
        assert(so.size.match(/\d+/))
      end
    end
  end
end
