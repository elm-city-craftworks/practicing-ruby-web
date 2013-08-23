class Broadcaster
  def self.notify_subscribers(params)
    BroadcastMailer.recipients.each do |subscriber|
      BroadcastMailer.broadcast(params, subscriber).deliver
    end
  end

  def self.notify_testers(params)
    subscriber = Struct.new(:contact_email)

    BroadcastMailer.broadcast(params, subscriber.new(params[:to])).deliver
  end
end
