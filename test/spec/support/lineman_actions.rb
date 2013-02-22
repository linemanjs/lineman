module LinemanActions
  BIN= File.join(File.dirname(__FILE__), "../../../cli.js")

  def lineman_new
    `
    mkdir -p tmp
    cd tmp
    rm -rf pants
    #{BIN} new pants
    `
  end


  def lineman_build
    `
    cd tmp/pants
    #{BIN} build
    `
  end

  def lineman_tear_down
    `rm -rf tmp`
  end
end