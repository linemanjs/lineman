require_relative 'capy_helper'
require 'fileutils'

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

    @@run_thread = if defined?(@@run_thread) && @@run_thread.alive?
      @@run_thread
    else
      start_lineman_run
    end
  end

  def lineman_tear_down
    sh 'rm -rf tmp'
  end

  def add_file(path, contents = "")
    location = project_path(path)
    create_dir_for(location)
    File.open(location, "w" ) do |file|
      file.write(contents)
    end
  end

  def edit_file(path, search, replace)
    location = project_path(path)
    new_contents = File.read(location).gsub(search, replace)
    File.open(location, "w") do |file|
      file.write(new_contents)
    end
  end

  def remove_file(path)
    sleep(1) #sucks, but grunt watch blows up if we delete during compilation
    File.delete(project_path(path))
  end

private

  def project_path(path)
    File.join(File.dirname(__FILE__),"/../../tmp/pants/",path)
  end

  def create_dir_for(path)
    dir = File.dirname(path)
    FileUtils.mkdir_p(dir) unless File.exist?(dir) #TODO - how to do mkdir -p??
  end

  def sh(command)
    `#{command}`.tap do |output|
      unless $?.success?
        msg = <<-ERR
          Command  failed! You ran:
          #{command}

          STDOUT:
          #{output}
        ERR
        puts msg
        raise msg
      end
    end
  end

  def start_lineman_run
    Thread.abort_on_exception = true
    Thread.new do
      sh <<-BASH
        mkdir -p tmp/pants
        cd tmp/pants
        #{BIN} run --stack
      BASH
    end
  end
end
