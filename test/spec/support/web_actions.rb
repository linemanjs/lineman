module WebActions
  def visit_harder(path)
    do_until { visit(path)["status"] == "success" }
  end

  def do_until(wait = 0.5, time_left = 5, &blk)
    raise "Failed to to perform task in time!" if time_left <= 0
    unless blk.call
      sleep(wait)
      do_until(wait, time_left - wait, &blk)
    end
  end

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