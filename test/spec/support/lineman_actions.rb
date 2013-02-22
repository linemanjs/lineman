module LinemanActions
  ROOT = File.join(File.dirname(__FILE__), "../../..")
  BIN= File.join(ROOT, "cli.js")

  def lineman_new
    `
    mkdir -p tmp
    cd tmp
    rm -rf pants
    #{BIN} new pants --skip-install
    cd pants
    mkdir -p node_modules
    ln -s #{ROOT} node_modules/lineman
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