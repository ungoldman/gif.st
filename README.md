gif.st - Social Web App meets Gifs
==================

Back-end is using @kyledrake's [Sammy Davis Junior](https://github.com/kyledrake/sammy_davis_jr) as an MVC boilerplate.

Using @mirven's [twitter oauth sinatra demo](https://github.com/mirven/twitter-oauth-sinatra) as a basis for twitter authentication, employing the oauth and grackle gems.

Using Heroku's cedar stack at [gif.herokuapp.com](http://gif.herokuapp.com) for hosting.

Using Twitter's brand new [Bootstrap](http://twitter.github.com/bootstrap/) for user interface development.

Using Amazon S3 for file hosting.

In other words, no dollars were spent in the making of this site.

Completed:
----------

* Use Sammy Davis Jr for Ruby boilerplate
* Implement Twitter OAuth
* Deploy to Heroku's Cedar stack for staging
* Use Twitter Bootstrap for CSS boilerplate
* Build UI
* Connect to Amazon S3
* Write Gif & User models
* Create persistent users from OAuth user data
* Write CRUD for Gifs
* Implement Short URLs

Next steps:
-----------

* Build rating & favorites system
* Implement asymmetrical friending
* Allow pasting URLs for gif upload
* Allow posts to Twitter
