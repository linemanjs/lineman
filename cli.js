#!/usr/bin/env node
require('coffee-script');
var path = require('path'),
    linemanDir = require('./finds-lineman-dir').find();

require(path.join(linemanDir, "lib", "cli", "main"))();
