require 'rspec/given'
require 'support/capy_helper'
require 'support/lineman_actions'
require 'support/web_actions'


RSpec.configure do |config|
  CapyHelper.set_up_capybara(config)

  config.include LinemanActions
  config.include WebActions

  config.before(:all) do
    lineman_tear_down
    lineman_new
  end

  config.after(:all) do
    lineman_tear_down
  end
end
