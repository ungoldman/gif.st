gif.st - Social Web App meets Gifs
==================
_because why not_
-----------------

Pre-Alpha Extreme Edition is using @kyledrake's [Sammy Davis Junior](https://github.com/kyledrake/sammy_davis_jr) as an MVC boilerplate.

After experiencing some false starts when attempting to use the sinatra-twitter-oauth gem and not getting much farther with the plain twitter-oauth gem, I opted to borrow heavily from @mirven's [twitter oauth sinatra demo](https://github.com/mirven/twitter-oauth-sinatra) which uses the oauth and grackle gems for some basic login, authentication and status grabbing functionality.

This app is currently deployed on Heroku's cedar stack at [gif.herokuapp.com](http://gif.herokuapp.com) for maximum risk, instability and experimentation.

I'm also trying out Twitter's brand new [Bootstrap](http://twitter.github.com/bootstrap/) CSS UI kit (using LESS.js, no less).

Completed:
----------

* Use Sammy Davis Jr for Ruby boilerplate
* Implement Twitter OAuth
* Deploy to Heroku's Cedar stack for staging
* Use Twitter Bootstrap for CSS boilerplate
* Build UI
* Connect to Amazon S3

Next steps:
-----------

* Write Gif & User models
* Write CRUD for Gifs
* Implement Short URLs
* Build rating & favorites system
* Allow posts to Twitter
