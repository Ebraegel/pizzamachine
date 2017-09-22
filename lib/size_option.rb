module PizzaMachine
  class SizeOption
    attr_accessor :size, :price, :shape, :gluten_free

    def initialize(**params)
      @size = params[:size]
      @shape = params[:shape]
      @gluten_free = params[:gluten_free] || false
      price_param = params[:price]
      @price = price_param.is_a?(String) ? price_param.gsub(/\$/,'') : price_param
    end

    def gluten_free?
      gluten_free
    end
  end
end
