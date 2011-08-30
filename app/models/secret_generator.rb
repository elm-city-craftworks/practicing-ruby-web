module SecretGenerator
  extend self

  def generate(length=30)
    (0...length).map{ ('a'..'z').to_a[rand(26)] }.join
  end
end