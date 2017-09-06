Bundler.require

class PizzaMachineWeb < Sinatra::Base
  enable  :logging

  get '/' do
    redirect ENV['SPREADSHEET_URL']
  end
end
