Bundler.require

enable  :logging

get '/' do
  redirect ENV['SPREADSHEET_URL']
end
