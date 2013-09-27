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

  describe "lineman run" do
    Given { lineman_run }
    When { visit_harder('/') }

    it_behaves_like "a global greeting"

    describe "adding a CoffeeScript file" do
      Given(:contents) { "window.pants = -> 'yay!'" }
      Given { add_file("app/js/foo.coffee", contents) }
      Then { eval_js("pants()").should == "yay!" }

      describe "editing the file" do
        Given { edit_file("app/js/foo.coffee", "pants", "hats") }
        Then { eval_js("hats()").should == "yay!" }
      end

      describe "removing the file" do
        Given { remove_file("app/js/foo.coffee") }
        Then { expect_js("window.pants === undefined") }
      end
    end

  end

  describe "app.js banner" do
    Given { lineman_build }
    Given(:banner) { "/*! An HTML/JS/CSS app - v0.0.1 - " }

    context "dev" do
      Given(:app_js) { file_contents "generated/js/app.js" }
      Then { app_js.should include banner }
    end

    context "dist" do
      Given(:app_js) { file_contents "dist/js/app.js" }
      Then { app_js.should include banner }
    end
  end


  describe "images" do
    Given(:img) { "double rainbow" }
    Given { add_file "app/img/app.jpg", img }
    Given { add_file "vendor/img/vendor.jpg", img }
    Given { lineman_build }

    context "dev" do
      Then { file_contents("generated/img/app.jpg").should == img }
      Then { file_contents("generated/img/vendor.jpg").should == img }
    end
    context "dist" do
      Then { file_contents("dist/img/app.jpg").should == img }
      Then { file_contents("dist/img/vendor.jpg").should == img }
    end
  end

end
