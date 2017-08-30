#!/usr/bin/env ruby

module PizzaMachine
  module Scraper
    class Parkway

      def self.run

        url = 'https://www.opendining.net/menu/56be296b515ee98d547b23c7'

        raw_page = Faraday.get(url)

        page = Nokogiri::HTML(raw_page.body)

        menu_item_and_price_array = []

        page.traverse do |node|
          menu_item_and_price_array << node if (node.name == "h3" || node.name == "option")
        end

        menu_item_and_price_array.map! {|e| e.children.text }.keep_if { |e| e.match(/Pizza|\d{2}\" \(\d{2}\.\d{2}\)/) }

        menu_item_and_price_array.map! { |e| e.split('" ') }

        parkway = PizzaMachine::PizzaPlace.new(name: "Parkway Pizza")

=begin
  This should leave us with something like:

[["Cheese/BYO Pizza"],
 ["12", "(11.29)"],
 ["14", "(12.89)"],
 ["16", "(14.29)"],
 ["Gluten Free 10", "(11.69)"],
 ["Veggie House Combo Pizza (House Favorite)"],
 ["10", "(11.89)"],
 ["12", "(15.89)"],
 ["14", "(19.95)"],
 ["16", "(22.95)"],
 ["Gluten Free 10", "(14.89)"],
 ["Artichoke Deluxe House Combo Pizza"],
 ["10", "(11.89)"],
 ["12", "(15.89)"],
 ["14", "(19.95)"],
 ["16", "(22.95)"],
 ["Glutten Free 10", "(14.89)"], 
 ... ]

=end

        pizza = PizzaMachine::Pizza.new

        menu_item_and_price_array.each do |e|
          if e[0].match("Pizza")
            pizza = PizzaMachine::Pizza.new(name: e[0])
            parkway.add_pizza(pizza)
          elsif e[0].match(/Glut/)
            pizza.add_size_option(size: "10", gluten_free: true, shape: "round", price: e[1].gsub(/\(|\)/,''))
          else
            pizza.add_size_option(size: e[0], shape: "round", price: e[1].gsub(/\(|\)/,''))
          end
        end

        return parkway
      end # run

    end # Parkway
  end # Scraper
end # PizzaMachine
