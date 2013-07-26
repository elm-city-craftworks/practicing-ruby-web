require 'test_helper'

class AuthorizationFailureTest < ActionDispatch::IntegrationTest
  test "auth failure page should load successfully" do
    visit auth_failure_path 
  end
end
