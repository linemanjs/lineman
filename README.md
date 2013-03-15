# Lineman

[![Build Status](https://secure.travis-ci.org/testdouble/lineman.png)](http://travis-ci.org/testdouble/lineman)

Lineman is a tool for bootstrapping fat-client webapp projects. It requires [node.js](http://nodejs.org) & [npm](http://npmjs.org) and wouldn't be possible without [grunt](https://github.com/cowboy/grunt).

Check out the [demo screencast!](http://www.youtube.com/watch?v=BmZ4XRErYAI)

## Do I need Lineman?

If you're starting a new project that will be deployed as static web assets, Lineman might be a great fit for you.

Some things it helps with:

* Immediately compile CoffeeScript, Less, and client-side templates as you edit source files
* Provide a development server for fast feedback
* Concatenate & minify all your CSS & JavaScript for production
* Run specs on demand with `lineman spec` using [Testem](https://github.com/airportyh/testem)
* Run specs with output suitable for your CI server using `lineman spec-ci`

Just think of it as a handful of conventions and tasks that can help you get up-and-running more quickly than deciding on path names and configuring all the requisite grunt tasks yourself.

## Getting started

First, you'll need [node.js](http://nodejs.org). You'll also need[PhantomJS](http://phantomjs.org) to run tests.

[Once you have those, [here's a screencast on how to get started](http://searls.testdouble.com/2012/10/13/say-hello-to-lineman/).]

Next, you'll need to install Grunt & Lineman globally:

``` bash
$ npm install -g grunt lineman
```

To create a new project, run the `lineman` binary with the `new` command and tell it where you'd like the project to go:

``` bash
$ lineman new my-project
```

This will create a new directory named "my-project" and copy in Lineman's [archetypal project](https://github.com/testdouble/lineman/tree/master/archetype).

Your new project will, by default, have Lineman and [grunt-contrib](https://github.com/gruntjs/grunt-contrib) as development dependencies.

Finally, you'll probably want to crack open your project' package.json file. That is, of course, unless you plan to give [John Doe](https://github.com/testdouble/lineman/blob/master/archetype/package.json) all the credit.

## Working with Lineman

### Development

To see all of the options available to you in the terminal use the `-h` or `--help` option:

``` bash
$ lineman --help
```

From the project directory, you can start a server at [localhost:8000](http://localhost:8000):

``` bash
$ lineman run
```

Internally, Grunt's `watch` task will monitor for file changes and Lineman will make sure that any requisite compilation & concatenation occur, based on the type and location of the file change.

With any luck, visiting the server in your browser will yield something as *beautiful* as this:

![Development Screenshot](http://i.minus.com/i1vI8cdB0tRPK.png)

The Hello World code shows off JST compilation, CoffeeScript, and Less. When you edit a source file, your changes are usually reflected by the time you can refresh your browser.

#### Server-side APIs

Lineman has a very narrow focus: helping you build client-side apps as a collection of ready-to-deploy static assets. That said, almost all nontrivial client-side apps require some interaction with a server, and no developer could be expected to write working code without either faking the server-side or plugging the client and server together. Lineman offers support for both!

##### Stubbing server-side endpoints

Users may define custom HTTP services to aid development in `config/server.js` by exporting a function named `drawRoutes`. Here's a trivial example:

``` javascript
module.exports = {
  drawRoutes: function(app) {
    app.get('/api/greeting/:message', function(req, res){
      res.json({ message: "OK, "+req.params.message });
    });
  }
};
```

With this definition in place, if the client-side app makes a request to "/api/greeting/ahoy!", this route will handle the request and return some JSON.

Because Lineman uses [express](http://expressjs.com) for the development server, please reference its documentation for details on all the nifty things you can do.

#### Proxying requests to another server

Lineman also provides a facility to forward any requests that it doesn't know how to respond to a proxy service. Typically, if you're developing a client-side app in Lineman and intend to pair it to a server-side app (written, say, in Ruby on Rails), you could run a local Rails server on port 3000 while running Lineman, and your JavaScript could seamlessly send requests to Rails on the same port as Lineman's development server.

To enable proxying, set the `enabled` flag on the `apiProxy` configuration of the `server` task in `config/application.js`, like this:

``` javascript
  server: {
    apiProxy: {
      enabled: true,
      port: 3000
    }
  }
```

With this feature, you'll be able to develop your client-side and server-side code in concert, while still keeping the codebases cleanly separated.

### Specs

Lineman provides a way to run your specs constantly as you work on your code with the `lineman spec` command:

``` bash
$ lineman spec
```

[**Note:** `lineman spec` requires `lineman run` to be running in a different process to monitor file changes..

The `spec` command will launch the fantastic test framework [Testem](https://github.com/airportyh/testem) supports Safari, Chrome, Firefox, Opera, PhantomJS and (IE9, IE8, IE7 if on Windows). By default we have configured Testem to launch Chrome for tests during development.

You can override this by modifying the `launch_in_dev` property within `config/spec.json`

We have found that running tests in Chrome during development is ideal as it enables the insertion of `debugger;` statements into javascript which allows debugging in the browser.

### Continuous Integration Specs

You can also run specs with output generated for your CI environment in [TAP 13](http://en.wikipedia.org/wiki/Test_Anything_Protocol) format:

``` bash
$ lineman spec-ci
```

This configuration executes specs headlessly using only PhantomJS. You can override this by modifying the `launch_in_ci` property within `config/spec.json`

### Production

When you're ready to send your application off to a remote server, just run the `lineman build` task.

``` bash
$ lineman build
```

The above runs a task that produces a production-ready web application in the project's `dist/` directory.

### Cleaning

To clean the two build directories (`dist` and `generated`), just run the clean task:

``` bash
$ lineman clean
```

## Project directory structure

Lineman generates a very particular directory structure. It looks like this:

``` bash
.
├── app
│   ├── js                  # <-- JS & CoffeeScript
│   ├── img                 # <-- images (are merged into the 'img' folder inside of generated & dist)
│   └── templates           # <-- client-side templates
│       ├── homepage.us     # <-- a template used to produce the application's index.html
│       ├── other.us        # <-- other templates will be compiled to a window.JST object
│       └── thing.hb        # <-- underscore & handlebars are both already set up
│       └── _partial.hb     # <-- a handlebars partial, usable from within other handlebars templates
├── config
│   ├── application.js      # <-- Override application configuration
│   ├── files.js            # <-- Override named file patterns
│   ├── server.js           # <-- Define custom server-side endpoints to aid in development
│   └── spec.json           # <-- Override spec run configurations
├── dist                    # <-- Generated, production-ready app assets
├── generated               # <-- Generated, pre-production app assets
├── grunt.js                # <-- gruntfile defines app's task config
├── package.json            # <-- Project's package.json
├── tasks                   # <-- Custom grunt tasks can be defined here
├── spec
│   ├── helpers             # <-- Spec helpers (loaded before other specs)
│   └── some-spec.coffee    # <-- All the Jasmine specs you can write (JS or Coffee)
└── vendor                  # <-- 3rd-party assets will be prepended or merged into the application
    ├── js                  # <-- 3rd-party Javascript
    │   └── underscore.js   # <-- Underscore, because underscore is fantastic.
    ├── img                 # <-- 3rd-party images (are merged into the 'img' folder inside of generated & dist)
    └── css                 # <-- 3rd-party CSS

```

## Troubleshooting

### Too Many Open Files

Lineman keeps a lot of files open at once. If you're seeing a message that looks like this:
    `undefined: [Lundefined:Cundefined] EMFILE, too many open files`

Try running `sudo launchctl limit maxfiles 2000 2100`. To have this setting persist across reboots, put the following in /etc/launchd.conf: `limit maxfiles 2000 2100`


# Deployment

## Heroku

Deploying your app to [heroku](http://heroku.com) couldn't be easier. Once you have the [heroku toolbelt](https://toolbelt.heroku.com) installed, simply run this from your project:

```
heroku create --stack cedar --buildpack http://github.com/testdouble/heroku-buildpack-lineman.git
```

Now, whenever you `git push heroku`, our [custom buildpack](http://github.com/testdouble/heroku-buildpack-lineman) will build your project with lineman and then start serving your minified site assets with apache!

What's really neat about this workflow is that while heroku takes care of building the assets for you (meaning you don't have to worry about checking in or transferring any generated assets), at runtime node is nowhere to be found! Your site is just static assets running on apache.

# About

## the name

Lineman got its name from finding that the word "grunt" was first used to describe unskilled railroad workers. Grunts that made the cut were promoted to linemen.

## the motivation

Most fat-client web applications are still written as second-class denizens within server-side project directories. This has inhibited the formation of a coherent community of people who write applications HTML, CSS, and JavaScript, because the server-side technology is dominant. Front-end work on a Rails project differs greatly from front-end work on a Java project, even though they're building the same thing!

All we wanted was a cozy & productive application development tool that didn't saddle our client-side code with a particular server-side technology. Intentionally dividing backend and front-end projects applies a healthy pressure to decouple the two.

It doesn't hurt that with Lineman, we're able to bootstrap new client-side apps faster than we ever have before.

## the terms

Lineman was created by [test double](http://testdouble.com), a software studio in Columbus, Ohio. It's distributed under the [MIT license](http://mit-license.org).

# Running Lineman's Tests

If you're interested in contributing to Lineman, it's probably worth knowing how to run Lineman's tests. It's a little tricky, because we're using Ruby & RSpec to integration-test a node project.

Once you've cloned lineman, here's all you need to install lineman's dependencies and the run its tests.

``` bash
$ npm install
$ cd test
$ bundle install
$ bundle exec rspec
```


