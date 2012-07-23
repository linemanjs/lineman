# Lineman

Lineman is a tool for bootstrapping web application projects. It requires [node.js](http://nodejs.org) & [npm](http://npmjs.org) and wouldn't be possible without [grunt](https://github.com/cowboy/grunt).

## Do I need Lineman?

If you're starting a new project that will be deployed as static web assets, Lineman might be a great fit for you. 

Some things it helps with:

* Immediately compile CoffeeScript, Less, and client-side templates as you edit source files
* Provide a development server for fast feedback
* Concatenate & minify all your CSS & JavaScript for production

Just think of it as a handful of conventions and tasks that can help you get up-and-running more quickly than deciding on path names and configuring all the requisite grunt tasks yourself.

## Getting started

To get started, install lineman globally:

``` bash
$ npm install -g lineman
```

To create a new project, run the lineman binary where you'd like the project to go:

``` bash
$ lineman my-new-project
```

This will create a new directory named "my-new-project" and copy Lineman's [archetypal project](https://github.com/testdouble/lineman/tree/master/archetype) in.

## Application lifecycle

### Development

From the project directory, you can start a server at [http://localhost:8000](localhost:8000): 

``` bash
$ grunt run
```

Grunt's watch task will monitor for file changes and Lineman's configuration will make sure that any requisite compilation & concatenation will occur based on the type of change.

### Production

When you want to do a full build & deploy, just run the default grunt task.

``` bash
$ grunt
```

The above run all of the defined tasks and produce a deployable web application in the project's `dist/` directory.

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