module WebActions
  def expect_css(locator, property, expected)
    js = <<-JS
      window.getComputedStyle(
        document.getElementsByClassName("#{locator}")[0]
      , null)["#{property}"];
    JS

    actual = page.evaluate_script(js.chop)

    expect(actual).to eq(expected)
  end
end