#!/usr/bin/env ruby

module PizzaMachine
  module Scraper
    class Carbones

      def self.get_items(page, section_selector)
        page.css("div.menu > div > a[name=\"#{section_selector}\"]").first.parent.css('div.item')
      end

      def self.add_items_to_menu(menu, items)
        items.each do |item|
          name = item.css('h4').text.strip
          menu[name] = {}
          item.css('div.multiprice').each do |option|
            size = option.css('span.title').text.split(' ')[0]
            price = option.css('span.price').text
            menu[name][size] = price
          end
        end
        menu
      end

      def self.remove_non_pizzas(menu)
        menu.delete_if { |pizza, options| options == {} || pizza == "Additional Toppings"}
      end

      def self.run

        carbones = PizzaMachine::PizzaPlace.new(name: "Carbone's")

        url = 'http://w.singlepage.com/carbones-pizza-on-the-parkway/menu'
        menu = {}

        page = Nokogiri::HTML(Faraday.get(url).body)

        add_items_to_menu(menu, get_items(page, 'Specialty Pizzas'))
        add_items_to_menu(menu, get_items(page, 'Build Your Own Pizza'))

        menu = remove_non_pizzas(menu)

        shape = "round"

        menu.each do |name, size_options|
          pizza = PizzaMachine::Pizza.new(name: name)
          carbones.add_pizza(pizza)
          size_options.each do |size, price|
            gluten_free = pizza.name.match(/Gluten/) ? true : false
            pizza.add_size_option(size: size, shape: shape, price: price, gluten_free: gluten_free)
          end
        end

        carbones
      end # run
    end # Davannis
  end # Scraper
end # PizzaMachine
