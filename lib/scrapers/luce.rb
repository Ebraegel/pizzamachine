#!/usr/bin/env ruby

module PizzaMachine
  module Scraper
    class Luce

      def self.run

        url = 'https://pizzaluce.com/menu/'

        page = Nokogiri::HTML(Faraday.get(url).body)
=begin
<...a bunch of stuff, but we start with the "menu-cat3" div and hope it NEVER CHANGES :) />
<div id="menu-cat3" class="menu-category in-scroll" style="opacity: 1;">
  <div class="menu-category-list">  
    <a name="specialty-pizza"></a>
    <div class="menu-category-title">
      <h3 class="serif">Specialty Pizza</h3>
      <p><em>Our award winning hand-tossed pizza begins with dough made fresh daily from whole grain flour and olive oil. Our gluten-free crusts are made fresh by a local gluten-free bakery.
        Small 10" Serves 1-2
        Medium 12" Serves 2-3
        Large 16" Serves 3-5
        Gluten-Free 10" Serves 1-2</em></p>
    </div>

    <div class="menu-item cat3 cat71 activeMenuItem activeItem">
      <div class="menu-img">
        <img src="http://pizzaluce.com//assets/photos/menu/BakedPotato.jpg" alt="Baked Potato Pizza  |&nbsp; GFR">
      </div>
      <div class="menu-txt">
        <h4 class="sans mgray bld">Baked Potato Pizza  |&nbsp; GFR</h4>
        <p>Idaholy Moly! We smother our pizza crust in&nbsp;buttery, garlic baby red mashed potatoes and top it with broccoli, fresh-diced tomatoes, cheddar cheese and chopped bacon. Served with a side of sour cream.</p>
        <p><strong>10” sm 14.49 | 12” med 18.19 | 16” lg 23.69 | GF 18.49</strong></p>
      </div>
    </div>
<...and more stuff follows>
=end
        # Get the divs with a class of "menu-item" inside the div with an id of menu-cat3
        # Hopefully, the specialty pizza section always has an ID of menu-cat3
        # Maybe by the time if changes I'll be way better at this
        specialty_menu_items = page.css("div#menu-cat3").css("div.menu-item")

        # Now get the text of all the h4 elements AND all the p elements (only those that are also strong) within menu-txt divs
        specialty_menu_item_text = specialty_menu_items.css("div.menu-txt").css('h4, p strong')
        menu = []
        specialty_menu_item_text.each { |e| menu << e.text }

=begin
menu = ["Baked Potato Pizza  |  GFR",
         "10” sm 14.49 | 12” med 18.19 | 16” lg 23.69 | GF 18.49",
         "Fire Breathing Dragon | GFR",
         "10” sm 14.49 | 12” med 18.19 | 16” lg 23.69 | GF 10\" 18.49",
         ... ]
=end

        menu.map! { |e| e.split('|') }

=begin
  
menu = [["Baked Potato Pizza  ", "  GFR"],
         ["10” sm 14.49 ", " 12” med 18.19 ", " 16” lg 23.69 ", " GF 18.49"],
         ["Fire Breathing Dragon ", " GFR"],
         ["10” sm 14.49 ", " 12” med 18.19 ", " 16” lg 23.69 ", " GF 10\" 18.49"],
         ... ]
=end

        luce = PizzaMachine::PizzaPlace.new(name: "Pizza Luce")
        shape = "round"

        byo_size_options = page.css("div#menu-catBYO").css("div.sizeopt")

        byo_size_options.each do |div|
          size_title = div.css("li.sizetitle").text
          # 10" Small: Servers 1-2
          # 12" Medium: serves 2-3
          # 16" Large: serves 3-5
          # Gluten Free 10": serves 1-2

          # nokogiri select by matching text.  Need to keep that in the brain-box for later.
          name = div.at('li:contains("Basic Cheese:")').children.first.text.gsub(/:/, '')

          pizza = PizzaMachine::Pizza.new(name: name)
          luce.add_pizza(pizza)


          size = size_title.match(/(\d+)"/)[1]
          gf = size_title.match?(/gluten/i) ? true : false
          price = div.at('li:contains("Basic Cheese:")').children.last.text.strip.gsub(/\$/, '')

          pizza.add_size_option(size: size, gluten_free: gf, price: price, shape: shape)
        end

        pizza = PizzaMachine::Pizza.new(name: name)

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
