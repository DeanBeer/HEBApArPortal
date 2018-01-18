module NRB::HEB
  class InvoicePaymentCollection < Struct.new(:payments)

    def self.from_json_hash(h)
      new h['aaData']
    end


    def initialize(*)
      super
      if( payments.respond_to? :each_with_index )
        payments.each_with_index do |p,i|
          if(p.is_a? Hash)
            payments[i] = InvoicePayment.from_json_hash(p)
          end
        end
      end
    end

  end
end
