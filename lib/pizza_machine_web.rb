Bundler.require

enable  :logging
use Raven::Rack

get '/' do
  redirect ENV['SPREADSHEET_URL']
end
