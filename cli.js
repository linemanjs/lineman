#!/usr/bin/env node
require('coffeescript/register');
var path = require('path'),
    linemanDir = require('./finds-lineman-dir').find();

require(path.join(linemanDir, "lib", "cli", "main"))();
