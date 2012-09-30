require 'test_helper'

class FailedRequestsTest < ActionDispatch::IntegrationTest
  test "responds with a 404 on missing pages" do
    visit "/volume/next-fed63d91b398e5ede229dd9bde03286d.png"

    assert_match "doesn't exist", page.body

    assert_equal 404, page.driver.status_code
  end
end
