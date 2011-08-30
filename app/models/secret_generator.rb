module SecretGenerator
  extend self

  def generate
    (0...30).map{ ('a'..'z').to_a[rand(26)] }.join
  end
end