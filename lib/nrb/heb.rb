module NRB::HEB
  autoload :ApArPortal, File.join('nrb', 'heb', 'ap_ar_portal')
  autoload :InvoiceLineItem, File.join('nrb', 'heb', 'invoice_line_item')
  autoload :InvoicePayment, File.join('nrb', 'heb', 'invoice_payment')
  autoload :InvoicePaymentCollection, File.join('nrb', 'heb', 'invoice_payment_collection')
end
