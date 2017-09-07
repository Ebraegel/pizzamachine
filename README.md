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
### Or, with Docker (experimental WIP)
```
docker build -t pizzamachine .
```

Development
====
* Create a Pizza Calculator spreadsheet (TODO: publish a template somewhere)
* Create a service account as described under "On behalf of no existing users (service account)" in https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md  
Save the provided service account key json file in the pizzamachine project if you want; clever .gitignores are trying real hard to prevent you from committing secrets.

* Give the service account read/write access to your pizza calculator spreadsheet.  The email address to grant access to is the "Service Account ID" found in your Google API project's "Credentials" > "Manage Service Accounts" section.

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

### Updating Pizza spreadsheets

`bin/rescrape_and_update_sheet.rb` will run all the scrapers and update your spreadsheet (provided you have set SPREADSHEET_URL and GOOGLE_DRIVE_SERVICE_ACCOUNT_KEY_JSON).  If you've set those env variables in Heroku, this works great, and you might want to set up a Heroku Scheduler schedule to `bundle exec bin/rescrape_and_update_sheet.rb`.  Even daily runs are probably overkill, so maybe find a different scheduling facility to use sometime.

However, in a local dev environment, it seems like dotenv has some trouble with command substitution in the .env file.  The easiest way around this is to just source the .env file before running the script:

```
. .env; bundle exec bin/rescrape_and_update_sheet.rb
```

### Run tests
```
bundle exec rake test

# or with docker (experimental WIP)
docker run pizzamachine bundle exec rake test
```

Heroku Deployment Instructions [WIP!]
====

```
heroku login
heroku git:remote -a your_app_name
# slurp your google drive service account creds into a config var
heroku config:set GOOGLE_DRIVE_SERVICE_ACCOUNT_KEY_JSON="$(< your_service_account_key_file.json)"
heroku config:set SPREADSHEET_URL='https://docs.google.com/spreadsheets/d/id-of-a-pizzacalculator-spreadsheet-accessible-to-your-service-account'
git push heroku master
```