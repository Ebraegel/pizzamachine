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
**TODO**: Dockerize all of this
Development
====

Shortcut to a pry session with all the classes loaded:

```
bin/pry-test-env
```

Once you're in there, try something like

```
luce = PizzaMachine::Scraper::Luce.run
```

### Run tests
```
bundle exec rake test
```

TODO
====

in no particular order

* Finish Dockerizing
* Figure out Google Sheets API
  * how to authorize the thing to access my sheet if it's running in Heroku or somewhere
  * how to get stuff from the spreadsheet
  * how to put stuff into the spreadsheet
* Once Google Sheets API is figured out, see if I can run all the scrapers and shove all the pizzas into the sheet to update it
  * What if one or more scraper fails?  Maybe some provision to update pizza place by pizza place, section by section on the CSV? Yikes.
* Get it into Heroku or something
* Schedule periodic parser runs?
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
* Handle specialty vs build-your-own
  * maybe figure out a size/topping cost multiplier for each pizza place and have a field on the sheet to choose the number of extra toppings?
  * What about places (e.g. Luce) that have different costs for different toppings?
  * This reminds me that a spreadsheet isn't really the best place to put all this stuff, but this started as an excuse to fiddle with the Sheets API, so don't judge.
    * Just make it a web app with Ms, Vs, and Cs already.
