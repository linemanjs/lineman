module LinemanActions
  BIN="../cli.js"

  def new_lineman(name)
    require 'ruby-debug'; debugger; 2;
    #`#{BIN} new #{name}`
  end

  def tear_down_lineman
  end

  def build_lineman
    `./node_modules/.bin/lineman build`
  end

end