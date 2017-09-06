require 'bundler'

Bundler.require

Dir['./lib/**/*.rb'].each { |f| require f }

run PizzaMachineWeb