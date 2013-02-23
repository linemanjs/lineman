require 'spec_helper'

describe "a basic project" do
  Given {  }
  Then {
    # lineman_build
    require 'ruby-debug'; debugger; 2;
    # lineman_build
    visit('tmp/pants/dist/index.html')
    page.should have_content("Hello, World!")
  }
end