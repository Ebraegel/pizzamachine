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
    assert_equal(false, @size_option.gluten_free)
  end
end
