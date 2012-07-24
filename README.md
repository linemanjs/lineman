# Lineman

Lineman is a tool for bootstrapping fat-client webapp projects. It requires [node.js](http://nodejs.org) & [npm](http://npmjs.org) and wouldn't be possible without [grunt](https://github.com/cowboy/grunt).

## Do I need Lineman?

If you're starting a new project that will be deployed as static web assets, Lineman might be a great fit for you.

Some things it helps with:

* Immediately compile CoffeeScript, Less, and client-side templates as you edit source files
* Provide a development server for fast feedback
* Concatenate & minify all your CSS & JavaScript for production

Just think of it as a handful of conventions and tasks that can help you get up-and-running more quickly than deciding on path names and configuring all the requisite grunt tasks yourself.

## Getting started

To get started, install Grunt & Lineman globally:

``` bash
$ npm install -g grunt lineman
```

To create a new project, run the `lineman` binary where you'd like the project to go:

``` bash
$ lineman my-new-project
```

This will create a new directory named "my-new-project" and copy in Lineman's [archetypal project](https://github.com/testdouble/lineman/tree/master/archetype).

Your new project will, by default, have Lineman and [grunt-contrib](https://github.com/gruntjs/grunt-contrib) as development dependencies. To install them:

``` bash
$ cd my-new-project; npm install
```

Finally, you'll probably want to crack open your project' package.json file. That is, of course, unless you plan to give [John Doe](https://github.com/testdouble/lineman/blob/master/archetype/package.json) all the credit.

## Working with Lineman

### Development

From the project directory, you can start a server at [localhost:8000](http://localhost:8000):

``` bash
$ grunt run
```

Grunt's `watch` task will monitor for file changes and Lineman will make sure that any requisite compilation & concatenation occur, based on the type and location of the file change.

With any luck, visiting the server in your browser will yield something as *beautiful* as this:

![Development Screenshot](http://i.minus.com/i1vI8cdB0tRPK.png)

The Hello World code shows off JST compilation, CoffeeScript, and Less. When you edit a source file, your changes are usually reflected by the time you can refresh your browser.

### Production

When you're ready to send your application off to a remote server, just run the default grunt task.

``` bash
$ grunt
```

The above runs a default task that produces a deployable web application in the project's `dist/` directory, ready to be deployed to production.

### Cleaning

To clean the two build directories (`dist` and `generated`), just run the clean task:

``` bash
$ grunt clean
```

## Project directory structure

Lineman generates a very particular directory structure. It looks like this:

``` bash
.
├── app
│   ├── js                  # <-- JS & CoffeeScript
│   ├── img                 # <-- images (are merged into the root of generated & dist)
│   └── templates           # <-- client-side templates
│       ├── homepage.us     # <-- a template used to produce the application's index.html
│       ├── other.us        # <-- other templates will be compiled to a window.JST object
│       └── thing.handlebar # <-- underscore & handlebars are both already set up
├── config
│   ├── application.js      # <-- Override application configuration
│   └── files.js            # <-- Override named file patterns
├── dist                    # <-- Generated, production-ready app assets
├── generated               # <-- Generated, pre-production app assets
├── grunt.js                # <-- gruntfile defines app's task config
├── package.json            # <-- Project's package.json
├── tasks                   # <-- Custom grunt tasks can be defined here
└── vendor                  # <-- 3rd-party assets will be prepended or merged into the application
    ├── js                  # <-- 3rd-party Javascript
    │   └── underscore.js   # <-- Underscore, because underscore is fantastic.
    ├── img                 # <-- 3rd-party images (are merged into the root of generated & dist)
    └── css                 # <-- 3rd-party CSS

```

# About

## the name

Lineman got its name from finding that the word "grunt" was first used to describe unskilled railroad workers. Grunts that made the cut were promoted to linemen.

## the motivation

Most fat-client web applications are still written as second-class denizens within server-side project directories. This has inhibited the formation of a coherent community of people who write applications HTML, CSS, and JavaScript, because the server-side technology is dominant. Front-end work on a Rails project differs greatly from front-end work on a Java project, even though they're building the same thing!

All we wanted was a cozy & productive application development tool that didn't saddle our client-side code with a particular server-side technology. Intentionally dividing backend and front-end projects applies a healthy pressure to decouple the two.

It doesn't hurt that with Lineman, we're able to bootstrap new client-side apps faster than we ever have before.

## the terms

Lineman was created by [test double](http://testdouble.com), a software studio in Columbus, Ohio. It's distributed under the [MIT license](http://mit-license.org).