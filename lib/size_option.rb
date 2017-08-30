module PizzaMachine
  class SizeOption
    attr_accessor :size, :price, :shape, :gluten_free

    def initialize(**params)
      @size = params[:size]
      @price = params[:price]
      @shape = params[:shape]
      @gluten_free = params[:gluten_free] || false
    end
  end
end