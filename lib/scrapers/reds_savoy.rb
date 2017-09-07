#!/usr/bin/env ruby

module PizzaMachine
  module Scraper
    class RedsSavoy

      def self.run

        url = 'http://savoypizza.com/location/minnesota/minneapolis-northeast/'

        page = Nokogiri::HTML(Faraday.get(url).body)

        specialty_menu_items = page.css("div#menu > table:nth-child(3) > tbody > tr")
        
        menu = {}

        specialty_menu_items.each do |tr|
          first_td = tr.css("td:nth-child(1)").text
          next unless first_td.match(/\n/)
          name = first_td.split("\n").first
          menu[name] = []
          menu[name] << tr.css("td:nth-child(2)").text
          menu[name] << tr.css("td:nth-child(3)").text
        end

=begin
menu
=> {"Savoy House Special"=>["$15.99", "$20.99"],
 "The Eastsider"=>["$16.99", "$22.99"],
 "The Hammer"=>["$12.99", "$18.99"],
 "Meat Lovers"=>["$14.99", "$20.99"],
 "Veggie"=>["$14.99", "$20.99"],
 "Hawaiian"=>["$11.99", "$16.99"],
 "Bacon Cheeseburger"=>["$14.99", "$20.99"],
 "Chicken Alfredo"=>["$12.99", "$17.99"],
 "Buffalo Chicken"=>["$12.99", "$17.99"],
 "BBQ Chicken"=>["$12.99", "$17.99"]}
=end

        reds_savoy = PizzaMachine::PizzaPlace.new(name: "Red's Savoy Pizza")
        shape = "round"

        menu.each do |name,size_options|
          pizza = PizzaMachine::Pizza.new(name: name)
          reds_savoy.add_pizza(pizza)
          pizza.add_size_option(size: "10", gluten_free: false, shape: shape, price: size_options.first.gsub(/\$/,''))
          pizza.add_size_option(size: "14", gluten_free: false, shape: shape, price: size_options.last.gsub(/\$/,''))
        end
        reds_savoy
      end # run
    end # RedsSavoy
  end # Scraper
end # PizzaMachine


