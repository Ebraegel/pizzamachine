require 'minitest/autorun'
require 'pizzamachine.rb'

class TestSizeOption < Minitest::Test
  def setup
    @size_option_options = {size: 16, price: 19.95, shape: "round"}
    @size_option = PizzaMachine::SizeOption.new(@size_option_options)
  end

  def test_creating_a_size_option
    assert_equal(@size_option_options[:size], @size_option.size)
    assert_equal(@size_option_options[:price], @size_option.price)
    assert_equal(@size_option_options[:shape], @size_option.shape)
  end

  def test_that_gluten_free_defaults_to_false
    assert_equal(@size_option.gluten_free, false)
  end

  def test_that_the_gluten_free_bool_is_false_when_the_size_option_is_not_gluten_free
    refute(@size_option.gluten_free?)
  end

  def test_that_the_gluten_free_bool_is_true_when_the_size_option_is_gluten_free
    @size_option.gluten_free = true
    assert(@size_option.gluten_free?)
  end

  def test_it_strips_dollar_signs_from_prices
    test_size_options = @size_option_options.merge({price: "$19.99"})
    size_option = PizzaMachine::SizeOption.new(test_size_options)
    assert_equal(size_option.price, "19.99")
  end
end
