require 'json'

module NRB::HEB::ApArPortal
  class JSONParser < Mechanize::File
    attr_reader :json, :payments
    def initialize(uri=nil, response=nil, bodi=nil, code=nil)
      super
      @json = JSON.load body
    end


    def parse_payments
      @payments = NRB::HEB::InvoicePaymentCollection.from_json_hash(@json)
    end

  end
end
