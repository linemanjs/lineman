#!/bin/bash -e

# Expected to be run from repo root.

mkdir -p test/bin
cd test/bin

export SELENIUM_SERVER_JAR="$(pwd)/selenium-server-standalone-$SELENIUM_VERSION.jar"

if [ ! -f $SELENIUM_SERVER_JAR ]; then
  wget http://selenium.googlecode.com/files/selenium-server-standalone-$SELENIUM_VERSION.jar
fi

java -jar $SELENIUM_SERVER_JAR > /dev/null 2>&1 &

cd ../..
