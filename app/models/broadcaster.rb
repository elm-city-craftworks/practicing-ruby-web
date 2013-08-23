class Broadcaster
  def self.notify_subscribers(params)
    BroadcastMailer.recipients.each do |email|
      BroadcastMailer.broadcast(params, email).deliver
    end
  end

  def self.notify_testers(params)
    BroadcastMailer.broadcast(params, params[:to]).deliver
  end
end
