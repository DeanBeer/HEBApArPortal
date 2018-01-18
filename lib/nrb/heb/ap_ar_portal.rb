require_relative 'ap_ar_portal/version'

module NRB::HEB
  module ApArPortal

    autoload :API, File.join('nrb','heb','ap_ar_portal','api')

    extend self

    URLs = { login_form: '/VendorPortal/loginPage',
             invoice: '/VendorPortal/secure/search/invoice',
             payment: '/VendorPortal/secure/search/detail/Payment/false',
             payments: '/VendorPortal/secure/search/payment',
             search: '/VendorPortal/secure/homePage?execution=e1s2',
           }

# Request URL:https://avp.heb.com/VendorPortal/secure/search/invoice?sEcho=2&iColumns=14&sColumns=&iDisplayStart=0&iDisplayLength=25&amDataProp=vendorNumber&amDataProp=recordType&amDataProp=number&amDataProp=date&amDataProp=amount&amDataProp=discountAmount&amDataProp=adjustmentAmount&amDataProp=paidAmount&amDataProp=scheduledPaymentDate&amDataProp=entryDate&amDataProp=receiptDate&amDataProp=function&amDataProp=numberOfLineItems&amDataProp=invoiceSequenceId&sSearch=&bRegex=false&asSearch=&abRegex=false&abSearchable=true&asSearch=&abRegex=false&abSearchable=true&asSearch=&abRegex=false&abSearchable=true&asSearch=&abRegex=false&abSearchable=true&asSearch=&abRegex=false&abSearchable=true&asSearch=&abRegex=false&abSearchable=true&asSearch=&abRegex=false&abSearchable=true&asSearch=&abRegex=false&abSearchable=true&asSearch=&abRegex=false&abSearchable=true&asSearch=&abRegex=false&abSearchable=true&asSearch=&abRegex=false&abSearchable=true&asSearch=&abRegex=false&abSearchable=false&asSearch=&abRegex=false&abSearchable=true&asSearch=&abRegex=false&abSearchable=true&iSortingCols=0&abSortable=true&abSortable=true&abSortable=true&abSortable=true&abSortable=true&abSortable=true&abSortable=false&abSortable=false&abSortable=true&abSortable=true&abSortable=true&abSortable=false&abSortable=true&abSortable=true&vendorNumber=9121406&allVendorNumbers=false&dateBegin=11%2F28%2F16&dateEnd=12%2F28%2F16&_=1482962105493

# Request Method:GET
# Status Code:200 OK
# Remote Address:199.59.41.40:443

# Response Headers
# Connection:Keep-Alive
# Content-Encoding:gzip
# Content-Type:application/json;charset=UTF-8
# Date:Thu, 29 Dec 2016 00:01:50 GMT
# ETag:"01e8d481df06a75fa8965bf46db9959fd"
# Keep-Alive:timeout=5, max=100
# Server:HEB Server
# Transfer-Encoding:chunked
# Vary:Accept-Encoding

# Request Headers
# Accept:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
# Accept-Encoding:gzip, deflate, sdch, br
# Accept-Language:en-US,en;q=0.8
# Cache-Control:max-age=0
# Connection:keep-alive
# Cookie:JSESSIONID=7d97185c9373f72a76762e5f1e8b; ROUTEID=.a38101; venNums=9121406
# DNT:1
# Host:avp.heb.com
# If-None-Match:"0626dc63b739e4d2078faa28396c124cd"
# Upgrade-Insecure-Requests:1
# User-Agent:Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.100 Safari/537.36

# Query String Parameters
# sEcho:2
# iColumns:14
# sColumns:
# iDisplayStart:0
# iDisplayLength:25
# amDataProp:vendorNumber
# amDataProp:recordType
# amDataProp:number
# amDataProp:date
# amDataProp:amount
# amDataProp:discountAmount
# amDataProp:adjustmentAmount
# amDataProp:paidAmount
# amDataProp:scheduledPaymentDate
# amDataProp:entryDate
# amDataProp:receiptDate
# amDataProp:function
# amDataProp:numberOfLineItems
# amDataProp:invoiceSequenceId
# sSearch:
# bRegex:false
# asSearch:
# abRegex:false
# abSearchable:true
# asSearch:
# abRegex:false
# abSearchable:true
# asSearch:
# abRegex:false
# abSearchable:true
# asSearch:
# abRegex:false
# abSearchable:true
# asSearch:
# abRegex:false
# abSearchable:true
# asSearch:
# abRegex:false
# abSearchable:true
# asSearch:
# abRegex:false
# abSearchable:true
# asSearch:
# abRegex:false
# abSearchable:true
# asSearch:
# abRegex:false
# abSearchable:true
# asSearch:
# abRegex:false
# abSearchable:true
# asSearch:
# abRegex:false
# abSearchable:true
# asSearch:
# abRegex:false
# abSearchable:false
# asSearch:
# abRegex:false
# abSearchable:true
# asSearch:
# abRegex:false
# abSearchable:true
# iSortingCols:0
# abSortable:true
# abSortable:true
# abSortable:true
# abSortable:true
# abSortable:true
# abSortable:true
# abSortable:false
# abSortable:false
# abSortable:true
# abSortable:true
# abSortable:true
# abSortable:false
# abSortable:true
# abSortable:true
# vendorNumber:9121406
# allVendorNumbers:false
# dateBegin:11/28/16
# dateEnd:12/28/16
# _:1482962105493

    VENDOR_NUM = "09121406".freeze

    autoload :Agent, File.join('nrb', 'heb', 'ap_ar_portal', 'agent')
    autoload :Credential, File.join('nrb', 'heb', 'ap_ar_portal', 'credential' )
    autoload :JSONParser, File.join('nrb', 'heb', 'ap_ar_portal', 'json_parser' )
    autoload :LoginHandler, File.join('nrb', 'heb', 'ap_ar_portal', 'login_handler')


    def self.default_start_date
      format_date (Date.today - 7)
    end


    def self.default_stop_date
      format_date Date.today
    end


    def self.format_date(date)
      date.strftime "%m/%d/%y"
    end


    def initiate_export
      # https://avp.heb.com/VendorPortal/secure/newExport/detail/false
      #  ?exportAll=true&searchKey=1163253792&exportKey=1482611441567&_=1482611441568
      { 'exportAll' => 'true',
        'searchKey' => '1163253792',
        'exportKey' => '1482611441567',
        '_' => '1482611441568'
      }
    end


    def invoice(num:, start: default_start_date, stop: default_stop_date)
      get URLs[:invoice], invoice_params(num: num, start: start, stop: stop)
    end


    def payment
      # Request URL:https://avp.heb.com/VendorPortal/secure/search/detail/Invoice/false?vendorNumber=09121406&number=7200&date=12%2F22%2F16&amount=55.30&invoiceSequenceId=74009139&numberOfLineItems=1&deductionsOnly=false&_=1482618942286
      # Request Method:GET
      # Status Code:200 OK
      # Remote Address:199.59.41.40:443
      # Response Headers
      # view source
      # Connection:Keep-Alive
      # Content-Encoding:gzip
      # Content-Type:application/json;charset=UTF-8
      # Date:Sun, 25 Dec 2016 00:36:45 GMT
      # ETag:"01eaa9f703edfb3c347bf2f5f620cd45b"
      # Keep-Alive:timeout=5, max=86
      # Server:HEB Server
      # Transfer-Encoding:chunked
      # Vary:Accept-Encoding
      # Request Headers
      # view source
      # Accept:application/json, text/javascript, */*; q=0.01
      # Accept-Encoding:gzip, deflate, sdch, br
      # Accept-Language:en-US,en;q=0.8
      # Connection:keep-alive
      # Cookie:JSESSIONID=356603b2f4e796ded39862742e9d; ROUTEID=.a38101; venNums=9121406
      # DNT:1
      # Host:avp.heb.com
      # Referer:https://avp.heb.com/VendorPortal/secure/homePage?execution=e1s2&recordType=invoice&invoiceNumber=7200&recordDate=12/22/16&recordDateEnd=12/22/16
      # User-Agent:Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.100 Safari/537.36
      # X-Requested-With:XMLHttpRequest
      # Query String Parameters
      # view source
      # view URL encoded
      # vendorNumber:09121406
      # number:7200
      # date:12/22/16
      # amount:55.30
      # invoiceSequenceId:74009139
      # numberOfLineItems:1
      # deductionsOnly:false
      # _:1482618942286
    end


    def payments(start: default_start_date, stop: default_stop_date)
      r = get URLs[:payments], payments_params(start: start, stop: stop)
      r.parse_payments
      r
    end

  private

    def agent(debug: true)
      a = Agent.instance
      if( debug )
        a.log = debug.is_a?(Logger) ? debug : default_logger
      end
      a
    end


    def default_logger
      l = Logger.new STDERR
      l.level = 0
      l
    end


    def format_date(date)
      self.class.format_date date
    end


    def get(*args)
      agent.get *args
    end


    def common_params
      {
        "abRegex"=>"false",
        "abSearchable"=>"true",
        "abSortable"=>"true",
        "asSearch"=>"",
        "bRegex"=>"false",
        "iDisplayStart"=>"0",
        "iDisplayLength"=>"25",
        "iSortingCols"=>"0",
        "sEcho"=>"1",
        "sColumns"=>"",
        "sSearch"=>"",
        "vendorNumber"=> VENDOR_NUM,
      }
   end


    def invoice_params(num:, start:, stop:)
      common_params.merge({
        "iColumns"=>"14",
        "amDataProp"=>"invoiceSequenceId",
        "allVendorNumbers"=>"false",
        "invoiceNumber"=> num,
        "dateBegin"=> start,
        "dateEnd"=> stop
      })
    end


    def payments_params(start:, stop:)
      common_params.merge({
        "iColumns"=>"9",
        "amDataProp"=>"numberOfLineItems",
        "dateBegin"=> start,
        "dateEnd"=> stop
      })
    end

  end
end

unless( Module.const_defined? :Portal )
  Portal = NRB::HEB::ApArPortal
end

unless( Module.const_defined? :ApArPortal )
  ApArPortal = NRB::HEB::ApArPortal
end
