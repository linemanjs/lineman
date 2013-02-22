require 'rspec/given'
require 'support/lineman_actions'

def set_up_capybara(port)
  require 'capybara'
  require 'capybara/rspec'
  require 'capybara/poltergeist'

  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(app, :browser => :chrome)
  end

  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, :inspector => true)
  end

  Capybara.app_host = "http://localhost:#{port}"
  Capybara.default_wait_time = 5
  Capybara.default_driver = Capybara.current_driver = unless ENV['HEADFUL']
    require 'capybara/poltergeist'
    :poltergeist
  else
    :chrome
  end
end

RSpec.configure do |config|
  set_up_capybara(8000)
  config.include Capybara::DSL
  config.include LinemanActions

  config.before(:all) { lineman_new }
  config.after(:all) { lineman_tear_down }
end
