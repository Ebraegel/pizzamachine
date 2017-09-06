PizzaMachine
====
I'll give this a better name someday.

Installation
====
OSX/Linux only.
### Prerequisites
* [Homebrew](https://brew.sh/)
* [rbenv](https://github.com/rbenv/rbenv) (`brew install rbenv`)

### Setup
```
rbenv install
gem install bundler
bundle install
```
### Or, with Docker (experimental)
```
docker build -t pizzamachine .
```

Development
====
* Create a Pizza Calculator spreadsheet (TODO: publish a template somewhere)
* Create a Google service account, get its json key file, and give it access to your spreadsheet, as described in the Heroku Deployment Instructions section

```
cp .env.example .env
```

Fill in your development .env file with the spreadsheet url and path to your service account's key file


Shortcut to a pry session with all the classes loaded:

```
bundle exec bin/pry-test-env
```

Or, the same thing with docker (experimental WIP)

```
docker run -it pizzamachine
require_relative './lib/pizzamachine.rb'
```

Once you're in there, try something like

```
luce = PizzaMachine::Scraper::Luce.run
```

### Run tests
```
bundle exec rake test

# or with docker (experimental)
docker run pizzamachine bundle exec rake test
```

Heroku Deployment Instructions [WIP!]
====
* Create a service account as described under "On behalf of no existing users (service account)" in https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md  Save the provided service account key json file in the pizzamachine project if you want; clever .gitignores are trying real hard to prevent you from committing secrets.

* Give the service account read/write access to your pizza calculator spreadsheet.  The email address to grant access to is the "Service Account ID" found in your Google API project's "Credentials" > "Manage Service Accounts" section.


```
heroku login
heroku git:remote -a your_app_name
# slurp your google drive service account creds into a config var
heroku config:set GOOGLE_DRIVE_SERVICE_ACCOUNT_KEY_JSON="$(< your_service_account_key_file.json)"
heroku config:set SPREADSHEET_URL='https://docs.google.com/spreadsheets/d/id-of-a-pizzacalculator-spreadsheet-accessible-to-your-service-account'
git push heroku master
```

TODO
====

in no particular order

* Finish Dockerizing
  * get pry's magic pretty-printing working in the container
  * it just drops you in irb by default, figure out what to do instead when it's run for real
    * maybe a script to build and/or run the thing?  More research needed, maybe overlapping with the "figure out heroku" research.
* Figure out Google Sheets API
  * how to authorize the thing to access my sheet if it's running in Heroku or somewhere
  * how to get stuff from the spreadsheet [done]
  * how to put stuff into the spreadsheet [done]
* Once Google Sheets API is figured out, see if I can run all the scrapers and shove all the pizzas into the sheet to update it [done]
  * What if one or more scraper fails?  Maybe some provision to update pizza place by pizza place, section by section on the CSV? Yikes.
* Get it into Heroku or something
  * Figure out secret management
  * maybe make a new "service account" for google to actually own the sheets (so my personal account isn't compromised if heroku or I fuck up)
  * maybe make appname.herokuapp.com go straight to the spreadsheet (read-only)
* Schedule periodic parser runs? (heroku clock thingy?)
* Schedule periodic tests or some way to validate my parsers (what to do if the menus change and I pull in weird results?)
* Add some exceptions to the parsers and/or data structure classes - a lot is flying on assumptions right now
* Add more menu parsers
  * Probably find some ways to DRY the parsers?
  * Possible places to add
    * Broadway
    * Dominos (yeah...)
    * Papa Murphy's
    * Davanni's
    * Red's Savoy
    * Casey's
    * Topper's
* Handle specialty vs build-your-own
  * maybe figure out a size/topping cost multiplier for each pizza place and have a field on the sheet to choose the number of extra toppings?
  * What about places (e.g. Luce) that have different costs for different toppings?
  * This reminds me that a spreadsheet isn't really the best place to put all this stuff, but this started as an excuse to fiddle with the Sheets API, so don't judge.
    * Just make it a web app with Ms, Vs, and Cs already.

