require "test_helper"

class CardExpirerTest < ActiveSupport::TestCase
  setup do
    #FIXME: Less duplication, push into factories w. better names?

    @users = {}
    @users[:active_expiring]   = FactoryGirl.create(:user, :status => "active")
    @users[:inactive_expiring] = FactoryGirl.create(:user, :status => "disabled")
    @users[:non_expiring]      = FactoryGirl.create(:user, :status => "active") 


    @cards = {}
    
    @cards[:active_expiring]   = FactoryGirl.create(:credit_card,
                                   :expiration_month => Date.today.month,
                                   :expiration_year  => Date.today.year,
                                   :user             => @users[:active_expiring])

    @cards[:inactive_expiring] = FactoryGirl.create(:credit_card,
                                   :expiration_month => Date.today.month,
                                   :expiration_year  => Date.today.year,
                                   :user             => @users[:inactive_expiring])

    @cards[:non_expiring]      = FactoryGirl.create(:credit_card,
                                   :expiration_month => Date.today.month,
                                   :expiration_year  => Date.today.year + 1,
                                   :user             => @users[:active_expiring])

    # Just a quick validation to alert us of a bad testing rig
    #
    assert(@users.values.map { |e| e.contact_email }.uniq.size == @users.size, 
          "Programmer error, check your factories")
  end

  test "only sends notifications to active subscribers" do
    CardExpirer.call(Date.today)

    assert ActionMailer::Base.deliveries.count == 1, "Should only send one expiration notice"

    assert_equal [@users[:active_expiring].contact_email], 
                 ActionMailer::Base.deliveries.first.to
  end
end
