module PizzaMachine
  class PizzaPlace
    attr_accessor :name, :pizzas

    def initialize(**params)
      @name = params[:name]
      @pizzas = []
    end

    def add_pizza(pizza)
      pizza.add_to_pizza_place(self)
    end

    def is_sane?
      self.has_at_least_five_pizzas? &&
        self.each_pizza_has_at_least_two_size_options? &&
        self.each_size_option_has_a_valid_price? &&
        self.each_size_option_has_a_valid_size? &&
        self.each_price_can_be_cast_to_float?
    end

    def has_at_least_five_pizzas?
      self.pizzas.length >= 5
    end

    def each_pizza_has_at_least_two_size_options?
      result = true
      self.pizzas.each do |pizza|
        result = false unless pizza.size_options.length >= 2
      end
      result
    end

    def each_size_option_has_a_valid_price?
      result = true
      self.pizzas.each do |pizza|
        pizza.size_options.each do |so|
          result = false unless so.price.match(/^\d+\.\d+$/)
        end
      end
      result
    end

    def each_size_option_has_a_valid_size?
      result = true
      self.pizzas.each do |pizza|
        pizza.size_options.each do |so|
          result = false unless so.size.match(/^\d+$/)
        end
      end
      result
    end

    def each_price_can_be_cast_to_float?
      result = true
      self.pizzas.each do |pizza|
        pizza.size_options.each do |so|
          result = false unless (!!Float(so.price) rescue false)
        end
      end
      result
    end
  end
end
