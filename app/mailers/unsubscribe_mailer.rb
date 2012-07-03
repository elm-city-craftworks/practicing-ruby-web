class UnsubscribeMailer < ActionMailer::Base
  default :from => "Practicing Ruby <gregory@practicingruby.com>"

  def unsubscribed(addresses)
    addresses.each do |address|
      mail(:to      => address,
           :subject => "Sorry to see you go").deliver
    end
  end
end
