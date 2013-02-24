require 'spec_helper'

describe "the hello world project" do

  shared_examples_for "a global greeting" do
    Then { page.should have_content("Hello, World!") }
    And { expect_css("hello", "backgroundColor", "rgb(239, 239, 239)") }
  end

  it_behaves_like "a global greeting" do
    Given { lineman_build }
    When { visit('tmp/pants/dist/index.html') }
  end

  it_behaves_like "a global greeting" do
    Given { lineman_run }
    When { visit_harder('/') }
  end

end