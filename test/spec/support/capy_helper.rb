class CapyHelper
  def self.set_up_capybara(rspec_config)
    require 'capybara'
    require 'capybara/rspec'
    require 'capybara/poltergeist'

    rspec_config.include Capybara::DSL

    set_capybara_host(:file)
    Capybara.default_wait_time = 5

    Capybara.register_driver :chrome do |app|
      Capybara::Selenium::Driver.new(app, :browser => :chrome)
    end

    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, :inspector => true)
    end

    Capybara.default_driver = Capybara.current_driver = unless ENV['HEADFUL']
      :poltergeist
    else
      :chrome
    end
  end

  def self.set_capybara_host(mode = :web, port = 8000)
    if mode == :web
      Capybara.app_host = "http://localhost:#{port}"
    else
      Capybara.app_host = "file://#{File.dirname(__FILE__)}/../../"
    end
  end
end