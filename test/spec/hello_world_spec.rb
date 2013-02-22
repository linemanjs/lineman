require 'spec_helper'

describe "a basic project" do
  Given { lineman_build }
  Then {
    require 'ruby-debug'; debugger; 2;
  }
end