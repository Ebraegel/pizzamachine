#!/usr/bin/env ruby

module PizzaMachine
  module Scraper
    class Davannis

      def self.get_items(url)
        Nokogiri::HTML(Faraday.get(url).body).css("div.item")
      end

      def self.add_items_to_menu(menu, items)
        items.each do |item|
          name = item.css("h5.itemLabel").text
          menu[name] = []
          item.css("span").each do |price|
            menu[name] << price.text.gsub(/\$/, '')
          end
        end
        menu
      end

      def self.run
        # Just guessing at sizes here.  These should be updated after further reconnaissance!
        solo = '6'
        medium = '10'
        large = '16'

        davannis = PizzaMachine::PizzaPlace.new(name: "Davanni's")

        url = 'https://davannisroseville.foodtecsolutions.com/menu?category=Legendary+Pizza#'
        menu = {}

        gf_url = 'https://davannisroseville.foodtecsolutions.com/menu?category=10%22+Gluten+Free+Pizzas'
        gf_menu = {}

        menu = add_items_to_menu(menu, get_items(url))
        gf_menu = add_items_to_menu(gf_menu, get_items(gf_url))

        shape = "round"

        menu.each do |name, prices|
          pizza = PizzaMachine::Pizza.new(name: name)
          davannis.add_pizza(pizza)
          pizza.add_size_option(size: solo, gluten_free: false, shape: shape, price: prices[0])
          pizza.add_size_option(size: medium, gluten_free: false, shape: shape, price: prices[1])
          pizza.add_size_option(size: large, gluten_free: false, shape: shape, price: prices[2])
        end

        gf_menu.each do |name, prices|
          pizza = PizzaMachine::Pizza.new(name: name)
          davannis.add_pizza(pizza)
          pizza.add_size_option(size: '10', gluten_free: true, shape: shape, price: prices[0])
        end

        davannis
      end # run
    end # Davannis
  end # Scraper
end # PizzaMachine
