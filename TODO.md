TODO
====

in no particular order 

* Finish Dockerizing
  * get pry's magic pretty-printing working in the container
  * it just drops you in irb by default, figure out what to do instead when it's run for real
    * maybe a script to build and/or run the thing?  More research needed, maybe overlapping with the "figure out heroku" research.
* Figure out Google Sheets API [done]
  * how to authorize the thing to access my sheet if it's running in Heroku or somewhere [done]
  * how to get stuff from the spreadsheet [done]
  * how to put stuff into the spreadsheet [done]
* Once Google Sheets API is figured out, see if I can run all the scrapers and shove all the pizzas into the sheet to update it [done]
  * What if one or more scraper fails?  Maybe some provision to update pizza place by pizza place, section by section on the CSV? Yikes.
* Get it into Heroku or something
  * Figure out how to set up Sentry or Airbrake or something so I know if everything goes wrong.
  * Figure out secret management [done?]
  * maybe make a new "service account" for google to actually own the sheets (so my personal account isn't compromised if heroku or I fuck up) [done]
  * maybe make appname.herokuapp.com go straight to the spreadsheet (read-only) [done]
* Schedule periodic parser runs? (heroku clock thingy?) [done]
* Schedule periodic tests or some way to validate my parsers (what to do if the menus change and I pull in weird results?)
  * set up CI to run tests
* Add some exceptions to the parsers and/or data structure classes - a lot is flying on assumptions right now
  * The scrape/update script will now bail out if it thinks any of the scraping results are invalid.  Can probably do more with this.
* Add more menu parsers
  * Probably find some ways to DRY the parsers?
  * Figure out a decent way to handle "choose a nearby store" stuff with national chains.  So far, it's been simplest to do local places.
  * Coupons?
  * Possible places to add
    * Broadway
    * Dominos (yeah...)
    * Papa Murphy's
    * Davanni's
    * Red's Savoy [done]
    * Casey's (this is a joke but I'm curious)
    * Topper's
* Handle specialty vs build-your-own
  * maybe figure out a size/topping cost multiplier for each pizza place and have a field on the sheet to choose the number of extra toppings?
  * What about places (e.g. Luce) that have different costs for different toppings?
  * This reminds me that a spreadsheet isn't really the best place to put all this stuff, but this started as an excuse to fiddle with the Sheets API, so don't judge.
    * Just make it a web app with Ms, Vs, and Cs already.
