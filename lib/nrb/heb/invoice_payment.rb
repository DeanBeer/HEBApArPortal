module NRB::HEB
  class InvoicePayment < Struct.new(:amount, :date, :line_items, :number, :record_type)
    extend NRB::FromJSONHash

    JSON_ARGS = [ "amount", "date", "lineItems", "number", "recordType" ]


    def initialize(*)
      super
      if( line_items.respond_to? :each_with_index )
        line_items.each_with_index do |item,index|
          line_items[index] = InvoiceLineItem.from_json_hash item
        end
      end
    end

  end
end
