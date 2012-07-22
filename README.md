# Groan

We've been looking for a nice way to handle project lifecycle concerns for HTML/CSS/JS apps for a while. We've got great solutions in Ruby when we're using Rails, but many of our apps can be deployed as pure static assets, so we're working on this repo to prove out using [grunt](https://github.com/cowboy/grunt) for that purpose.

Ultimately, a few goals of this project:

* Watch & compile CoffeeScript, Less, and JSTs seamlessly.
* Classy Jasmine integration
* DRY configuration, especially around file paths, so we don't need to keep re-specifying lists of files to based on their necessary load order.
* Bundle up everything into a ready-to-deploy `dist` directory that contains a main index.html that points to concatenated/minified production JavaScript & CSS files.

Once we prove all this out, we'll extract the tasks we write and maybe even a project generator binary into an npm module, for a great project bootstrapping experience.

# running stuff

During development, start a server at [http://localhost:8080](localhost:8080) and watch file changes:

``` bash
$ grunt run
```

When you want to do a full build & deploy, just run the default grunt task:

``` bash
$ grunt
```

To clean the two generated directories (`dist` and `generated`), just run the clean task:

``` bash
$ grunt clean
```

# directory structure

An annotated directory structure:

``` bash
.
├── app
│   ├── js # <-- JS & CoffeeScript
│   ├── img # <-- images
│   └── templates # <-- client-side templates
│       ├── homepage.handlebar # <-- a template used to produce the actual static index.html
│       ├── other.handlebar
│       └── other-template.us
├── config
│   ├── application.js # <-- application configuration are exported here
│   └── files.js # <-- application file paths are exported here
├── dist # <-- production-ready built app would go here
├── generated # <-- all generated, non-dist assets
├── grunt.js
├── package.json
├── spec # <-- jasmine specs
│   └── js
│       └── foo-spec.js
├── tasks # <-- Custom grunt tasks
│   ├── sometask.js
└── vendor # <-- vendor assets (js, css, img)
    └── js
        └── underscore.js

```