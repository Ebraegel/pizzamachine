#!/usr/bin/env ruby

require 'google_drive'
require_relative '../lib/pizzamachine.rb'

session = GoogleDrive::Session.from_service_account_key(StringIO.new(ENV['GOOGLE_DRIVE_SERVICE_ACCOUNT_KEY_JSON']))
sheet = session.spreadsheet_by_url(ENV['SPREADSHEET_URL'])
ws = sheet.worksheets.first

row = 2

place_col = 1
type_col = 2
price_col = 3
diameter_round_col = 4
diameter_square_col = 5

pizza_places = [PizzaMachine::Scraper::Luce.run, PizzaMachine::Scraper::Parkway.run, PizzaMachine::Scraper::RedsSavoy.run]

pizza_places.each do |pizza_place|
  raise StandardError.new("The pizza place #{pizza_place.name} didn't pass sanity checks!\nDumping pizza_place.inspect and bailing on the whole update.  Good luck!\n\n#{pizza_place.inspect}\n") unless pizza_place.is_sane?
  pizza_place.pizzas.each do |pizza|
    pizza.size_options.each do |size_option|
      ws[row, place_col] = pizza_place.name
      ws[row, type_col] = size_option.gluten_free? ? pizza.name + ' [GF]' : pizza.name
      if size_option.shape == "round"
        ws[row, diameter_round_col] = size_option.size
      elsif size_option.shape = "square"
        ws[row, diameter_square_col] = size_option.size
      else 
        raise StandardError.new("The pizza's size option is neither round nor square: #{size_option.inspect}")
      end
      ws[row, price_col] = size_option.price
      row += 1
    end
  end
end

ws.save
