require 'test_helper'

class ProfileTest < ActionDispatch::IntegrationTest

  test "contact email is validated" do
    simulate do |user|
      user.register(Support::SimulatedUser.default)
      user.edit_profile(:email => "jordan byron at gmail dot com")
    end

    assert_content "Contact email is invalid"
  end

  def simulate(&block)
    Support::SimulatedUser.new(self).instance_eval(&block)
  end
end