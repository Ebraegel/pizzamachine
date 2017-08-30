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
  end
end