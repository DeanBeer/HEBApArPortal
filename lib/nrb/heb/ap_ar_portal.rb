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

    VENDOR_NUM = "09121406".freeze

    autoload :Agent, File.join('nrb', 'heb', 'ap_ar_portal', 'agent')
    autoload :Credential, File.join('nrb', 'heb', 'ap_ar_portal', 'credential' )
    autoload :LoginHandler, File.join('nrb', 'heb', 'ap_ar_portal', 'login_handler')


    def self.default_start_date
      format_date (Date.today - 30)
    end


    def self.default_stop_date
      format_date Date.today
    end


    def self.format_date(date)
      date.strftime "%m/%d/%y"
    end


    def payments(start: default_start_date, stop: default_stop_date)
      get URLs[:payments], payments_params(start: start, stop: stop)
    end


    def invoice(num:, start: default_start_date, stop: default_stop_date)
      get URLs[:invoice], invoice_params(num: num, start: start, stop: stop)
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
