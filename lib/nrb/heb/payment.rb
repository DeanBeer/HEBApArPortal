module NRB::HEB
  class Payment < Struct.new(:amount, :date, :line_items, :number, :record_type)

    JSON_ARGS = [ "amount", "date", "lineItems", "number", "recordType" ]

    def self.from_json_hash(hash)
      new *JSON_ARGS.collect { |i| hash[i] }
    end

  end
end
