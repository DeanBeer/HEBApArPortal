module NRB::HEB
  class InvoiceLineItem < Struct.new(:amount, :date, :location_name, :number, :paid_amount, :payment_date, :vendor_number)
    extend NRB::FromJSONHash

    JSON_ARGS = [ "amount", "date", "locationName", "number", "paidAmount", "paymentDate", "vendorNumber" ]

  end
end
