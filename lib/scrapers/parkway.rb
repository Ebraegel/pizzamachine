#!/usr/bin/env ruby

module PizzaMachine
  module Scraper
    class Parkway

      def self.run

        url = 'https://www.opendining.net/menu/56be296b515ee98d547b23c7'

        page = Nokogiri::HTML(Faraday.get(url).body)

        menu = {}

        page.css('div#menu > div').at('h2:contains("Pizza")').parent.css('ul > li.item').each do |li|
          name = li.css('form > div.item_header > div.item-info > h3').text
          menu[name] = []
          li.css('form > div.item_details > div.options > div.size-container > select > option').each do |size_option|
            menu[name] << size_option.text
          end
        end

=begin
  This should leave us with something like:

menu = {"Cheese/BYO Pizza"=>["10\" (8.69)", "12\" (11.29)", "14\" (12.89)", "16\" (14.29)", "Gluten Free 10\" (11.69)"],
 "Veggie House Combo Pizza (House Favorite)"=>["10\" (11.89)", "12\" (15.89)", "14\" (19.95)", "16\" (22.95)", "Gluten Free 10\" (14.89)"],
 "Artichoke Deluxe House Combo Pizza"=>["10\" (11.89)", "12\" (15.89)", "14\" (19.95)", "16\" (22.95)", "Glutten Free 10\" (14.89)"],
  ... }
=end
        parkway = PizzaMachine::PizzaPlace.new(name: "Parkway Pizza")

        menu.each do |name,size_options|
          pizza = PizzaMachine::Pizza.new(name: name)
          parkway.add_pizza(pizza)
          size_options.each do |size_option|
            if size_option.match(/Glut/)
              pizza.add_size_option(size: "10", gluten_free: true, shape: "round", price: size_option.gsub(/.*\(|\)/,''))
            else
              pizza.add_size_option(size: size_option.split('"')[0], shape: "round", price: size_option.gsub(/.*\(|\)/,''))
            end
          end
        end
        return parkway
      end # run

    end # Parkway
  end # Scraper
end # PizzaMachine
