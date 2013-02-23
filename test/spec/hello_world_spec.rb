require 'spec_helper'

describe "a basic project" do
  Given { lineman_build }
  When { visit('tmp/pants/dist/index.html') }
  Then { page.should have_content("Hello, World!") }
end