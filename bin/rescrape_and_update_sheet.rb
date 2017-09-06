#!/usr/bin/env ruby

Bundler.require
require_relative '../lib/pizzamachine.rb'

session = GoogleDrive::Session.from_service_account_key(File.expand_path("../../PizzaMachine-QC-1662e0d6e7be.json", __FILE__))
sheet = session.spreadsheet_by_title("Pizza Calculator - QC")
ws = sheet.worksheets.first

row = 2

place_col = 1
type_col = 2
price_col = 3
diameter_round_col = 4
diameter_square_col = 5

pizza_places = [PizzaMachine::Scraper::Luce.run, PizzaMachine::Scraper::Parkway.run]

pizza_places.each do |pizza_place|
  pizza_place.pizzas.each do |pizza|
    pizza.size_options.each do |size_option|
      ws[row, place_col] = pizza_place.name
      ws[row, type_col] = pizza.name
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