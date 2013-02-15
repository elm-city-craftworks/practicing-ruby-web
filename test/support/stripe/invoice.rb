module Support
  module Stripe
    class Invoice
      attr_accessor :id, :customer, :period_start, :date, :total, :paid,
                    :invoice_items, :closed

      Lines = Struct.new(:invoiceitems)

      def lines
        Lines.new(invoice_items)
      end

      def save
        # noop
      end
    end
  end
end