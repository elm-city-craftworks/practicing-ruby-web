class AuthorizationLink < ActiveRecord::Base
  belongs_to :authorization

  before_save do
    if mailchimp_email && secret.blank?
      write_attribute(:secret, SecretGenerator.generate)
    end
  end

  def self.activate(key)
    if link = find_by_secret(key)
      auth = link.authorization
      user = User.find_by_email(link.mailchimp_email)

      user.github_nickname = link.github_nickname
      user.save!

      auth.user_id = user.id
      auth.save!

      link.destroy
    else
      raise
    end
  end
end
