#!/bin/bash -e

# Expected to be run from repo root.

mkdir -p test/bin
cd test/bin

SELENIUM_VERSION=${SELENIUM_VERSION-2.38.0}

export SELENIUM_SERVER_JAR="$(pwd)/selenium-server-standalone-$SELENIUM_VERSION.jar"

if [ ! -f $SELENIUM_SERVER_JAR ]; then
  wget http://selenium.googlecode.com/files/selenium-server-standalone-$SELENIUM_VERSION.jar
fi

# Drop stuff where webdriver-sync wants to see it.
mkdir ~/.webdriver-sync
ln -s $SELENIUM_SERVER_JAR "$HOME/.webdriver-sync/selenium-server-standalone.jar"
touch ~/.webdriver-sync/chromedriver
