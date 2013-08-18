module Support
  class Outbox
    def initialize(test, messages)
      @test     = test
      @messages = messages
    end

    attr_reader :messages

    def has_message_with(params)
      subject_matches = false
      bcc_matches     = false

      matched_messages = @messages.select do |e|
        subject_matches = e.subject.match(params.fetch(:subject, //)) 

        bcc_matches     = if params[:bcc]
                            Set[*e.bcc] == Set[*params[:bcc]]
                          else
                            true
                          end

        subject_matches && bcc_matches
      end

      unless matched_messages.count == params.fetch(:count, 1)
        @test.assert subject_matches, "Expected subject to match but didn't"
        @test.assert bcc_matches,     "Expected bcc to match but didn't"

        @test.flunk "Number of delivered messages was not as expected"
      end
    end

  end
end
