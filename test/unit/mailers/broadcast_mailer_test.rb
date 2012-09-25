class BroadcastMailerTest < ActionMailer::TestCase
  test "emails should not be escaped" do
    assert ActionMailer::Base.deliveries.empty?

    BroadcastMailer.deliver_broadcast(:body    => "It's working",
                                      :subject => "TEST",
                                      :to      => "test@test.com",
                                      :commit  => "Test")

    message = ActionMailer::Base.deliveries.first

    assert_equal "It's working\n", message.body.to_s
  end
end
