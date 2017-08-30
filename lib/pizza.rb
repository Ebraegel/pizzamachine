module PizzaMachine
  class Pizza
    attr_accessor :name, :pizza_place, :size_options

    def initialize(**params)
      @size_options = []
      @name = params[:name]
      @pizza_place = params[:pizza_place]
    end

    def add_size_option(size_option)
      if size_option.is_a? PizzaMachine::SizeOption
        @size_options << size_option
      else
        @size_options << PizzaMachine::SizeOption.new(size_option)
      end
    end

    def add_to_pizza_place(pizza_place)
      pizza_place.pizzas << self
      @pizza_place = pizza_place
    end

  end
end
