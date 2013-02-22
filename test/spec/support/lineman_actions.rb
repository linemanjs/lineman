module LinemanActions
  BIN="../cli.js"

  def lineman_new
    `
    mkdir -p tmp
    cd tmp
    rm -rf pants
    #{BIN} new pants
    `
  end


  def lineman_build
    `./node_modules/.bin/lineman build`
  end

  def lineman_tear_down
    `rm -rf tmp`
  end
end