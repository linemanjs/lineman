require_relative 'capy_helper'

module LinemanActions
  ROOT = File.join(File.dirname(__FILE__), "../../..")
  BIN= File.join(ROOT, "cli.js")

  def lineman_new
    sh <<-BASH
      mkdir -p tmp
      cd tmp
      rm -rf pants
      #{BIN} new pants --skip-install
    BASH
    lineman_link
  end

  def lineman_link
    sh <<-BASH
      cd tmp/pants
      mkdir -p node_modules
      ln -s #{ROOT} node_modules/lineman
    BASH
  end

  def lineman_build
    CapyHelper.set_capybara_host(:file)

    sh <<-BASH
      cd tmp/pants
      #{BIN} build --stack
    BASH
  end

  def lineman_run
    CapyHelper.set_capybara_host(:web)

    Thread.new do
      sh <<-BASH
        cd tmp/pants
        #{BIN} run --stack
      BASH
    end
  end

  def lineman_tear_down
    sh 'rm -rf tmp'
  end

  def add_file(path, contents = "")
    location = File.join(File.dirname(__FILE__),"/../../tmp/pants/",path)
    create_dir_for(location)
    File.open(location, "w" ) do |file|
      file.write(contents)
    end
  end


private

  def create_dir_for(path)
    dir = File.dirname(path)
    Dir.mkdir(dir) unless File.exist?(dir) #TODO - how to do mkdir -p??
  end

  def sh(command)
    `#{command}`.tap do |output|
      unless $?.success?
        raise <<-ERR
          Command  failed! You ran:
          #{command}

          STDOUT:
          #{output}
        ERR
      end
    end
  end
end