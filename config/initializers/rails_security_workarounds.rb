# https://groups.google.com/forum/#!topic/rubyonrails-security/bahr2JLnxvk

ActiveSupport::XmlMini.backend = 'Nokogiri'

# https://groups.google.com/forum/#!topic/rubyonrails-security/7VlB_pck3hU
#
module ActiveSupport
  module JSON
    module Encoding
      
      private
      
      class EscapedString
        def to_s
          self
        end
      end
    end
  end
end
