#!/usr/bin/env ruby

module PizzaMachine
  module Scraper
    class Luce

      def self.run

        url = 'https://pizzaluce.com/menu/'

        page = Nokogiri::HTML(Faraday.get(url).body)

        menu = []

        page.traverse do |node|
          menu << node if (node.name == "h3" || node.name = "h4" || node.name = "p")
        end

        menu.keep_if {|e| ( e.class == Nokogiri::XML::Text && e.text.match(/\w+/) ) }

        menu.map!(&:text)

        while menu.include?("Specialty Pizza")
            i = menu.index("Specialty Pizza")
            menu = menu.drop(i+1)
        end

        menu.keep_if { |e| e =~ /\|/ }
        menu.delete_if { |e| e =~ /\=/ }

        luce = PizzaMachine::PizzaPlace.new(name: "Pizza Luce")

=begin

["Baked Potato Pizza  |  GFR",
 "10” sm 14.49 | 12” med 18.19 | 16” lg 23.69 | GF 18.49",
 "Fire Breathing Dragon | GFR",
 "10” sm 14.49 | 12” med 18.19 | 16” lg 23.69 | GF 10\" 18.49",
 ... ]
=end

        menu.map! { |e| e.split('|') }

=begin
  
[["Baked Potato Pizza  ", "  GFR"],
 ["10” sm 14.49 ", " 12” med 18.19 ", " 16” lg 23.69 ", " GF 18.49"],
 ["Fire Breathing Dragon ", " GFR"],
 ["10” sm 14.49 ", " 12” med 18.19 ", " 16” lg 23.69 ", " GF 10\" 18.49"],
 ... ]

=end

        pizza = PizzaMachine::Pizza.new
        shape = "round"

        menu.each do |a|
          if a.length == 2 # It must be a Pizza.  Clean up the name a bit and make a Pizza out of it.
            name = a[0].strip
            pizza = PizzaMachine::Pizza.new(name: name)
            luce.add_pizza(pizza)
          elsif a.length > 2 # Must be an array of size options.
            a.each do |so|
              price = so.split("\s")[-1]
              if so.match("GF")
                gluten_free = true
                size = "10"
              else 
                gluten_free = false
                size = so.match(/\d+/)[0]
              end
              pizza.add_size_option(price: price, gluten_free: gluten_free, size: size, shape: shape)
            end
          end
        end
        return luce
      end # run
    end # Parkway
  end # Scraper
end # PizzaMachine


