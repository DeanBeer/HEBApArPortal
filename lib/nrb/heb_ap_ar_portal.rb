require "nrb/heb_ap_ar_portal/version"
require 'io/console'
require 'json'
require 'yaml'

module NRB
  module HEBApArPortal

    extend self

    HOST = 'https://avp.heb.com'.freeze

    URLs = { login_form: HOST + '/VendorPortal/loginPage',
             invoice: HOST + '/VendorPortal/secure/search/invoice',
             payment: HOST + '/VendorPortal/secure/search/detail/Payment/false',
             payments: HOST + '/VendorPortal/secure/search/payment',
             search: HOST + '/VendorPortal/secure/homePage?execution=e1s2',
           }

    autoload :Agent, File.join('nrb', 'heb_ap_ar_portal', 'agent')
    autoload :Handler, File.join('nrb', 'heb_ap_ar_portal', 'handler')


    def agent(debug: true)
      a = Agent.instance
      if( debug )
        a.log = debug.is_a?(Logger) ? debug : default_logger
      end
      a
    end


    def logged_in?
      !! @logged_in
    end


    def payments
      login unless logged_in?
      agent.get URLs[:payments], payments_params
    end


    def payment(amount: "462.70", date: "12/16/16", num: "0000912729")
      login unless logged_in?
      agent.get URLs[:payment], payment_params(amount: amount, date: date, num: num)
    end


    def invoice(num:)
      login unless logged_in?
      agent.get URLs[:invoice], invoice_params(num: num)
    end


    def invoice_params(num:)
      {
        "sEcho" => "2",
        "iColumns" => "14",
        "sColumns" => "",
        "iDisplayStart" => "0",
        "iDisplayLength" => "25",
        "amDataProp" => "vendorNumber",
        "amDataProp" => "recordType",
        "amDataProp" => "number",
        "amDataProp" => "date",
        "amDataProp" => "amount",
        "amDataProp" => "discountAmount",
        "amDataProp" => "adjustmentAmount",
        "amDataProp" => "paidAmount",
        "amDataProp" => "scheduledPaymentDate",
        "amDataProp" => "entryDate",
        "amDataProp" => "receiptDate",
        "amDataProp" => "function",
        "amDataProp" => "numberOfLineItems",
        "amDataProp" => "invoiceSequenceId",
        "sSearch" => "",
        "bRegex" => "false",
        "asSearch" => "",
        "abRegex" => "false",
        "abSearchable" => "true",
        "asSearch" => "",
        "abRegex" => "false",
        "abSearchable" => "true",
        "asSearch" => "",
        "abRegex" => "false",
        "abSearchable" => "true",
        "asSearch" => "",
        "abRegex" => "false",
        "abSearchable" => "true",
        "asSearch" => "",
        "abRegex" => "false",
        "abSearchable" => "true",
        "asSearch" => "",
        "abRegex" => "false",
        "abSearchable" => "true",
        "asSearch" => "",
        "abRegex" => "false",
        "abSearchable" => "true",
        "asSearch" => "",
        "abRegex" => "false",
        "abSearchable" => "true",
        "asSearch" => "",
        "abRegex" => "false",
        "abSearchable" => "true",
        "asSearch" => "",
        "abRegex" => "false",
        "abSearchable" => "true",
        "asSearch" => "",
        "abRegex" => "false",
        "abSearchable" => "true",
        "asSearch" => "",
        "abRegex" => "false",
        "abSearchable" => "false",
        "asSearch" => "",
        "abRegex" => "false",
        "abSearchable" => "true",
        "asSearch" => "",
        "abRegex" => "false",
        "abSearchable" => "true",
        "iSortingCols" => "0",
        "abSortable" => "true",
        "abSortable" => "true",
        "abSortable" => "true",
        "abSortable" => "true",
        "abSortable" => "true",
        "abSortable" => "true",
        "abSortable" => "false",
        "abSortable" => "false",
        "abSortable" => "true",
        "abSortable" => "true",
        "abSortable" => "true",
        "abSortable" => "false",
        "abSortable" => "true",
        "abSortable" => "true",
        "vendorNumber" => "9121406",
        "allVendorNumbers" => "false",
        "invoiceNumber" => num,
        "dateBegin" => "01/01/14",
        "dateEnd" => "12/21/16",
      }
    end


    def payments_params
      {
        "sEcho"=>"1",
        "iColumns"=>"9",
        "sColumns"=>"",
        "iDisplayStart"=>"0",
        "iDisplayLength"=>"25",
        "amDataProp"=>"numberOfLineItems",
        "sSearch"=>"",
        "bRegex"=>"false",
        "asSearch"=>"",
        "abRegex"=>"false",
        "abSearchable"=>"true",
        "iSortingCols"=>"0",
        "abSortable"=>"true",
        "vendorNumber"=>"9121406",
        "dateBegin"=>"12/12/16",
        "dateEnd"=>"12/19/16",
      }
    end


    def payment_params(amount:, date:, num: )
      {
        "amount" => amount,
        "bankCode" => "CK2",
        "date" => date,
        "deductionsOnly" => "false",
        "invoiceSequenceId" => "undefined",
        "number" => num,
        "numberOfLineItems" => "10",
        "typeCode" => "EFT",
        "vendorNumber" => "09121406",
      }
    end

  private

    attr_accessor :password, :username

    def authentication_credentials
      @authentication_credentials ||= read_credentials || {
        user_field_name => get_username(prompt: "#{user_field_name}? "),
        pass_field_name => get_password(prompt: "#{pass_field_name}? ")
      }
    end

    def authenticate_url
      HOST + login_form.action
    end


    def csrf_token
      login_form_page.forms.last.csrfToken
    end


    def default_logger
      l = Logger.new STDERR
      l.level = 0
      l
    end


    def fetch_page(name)
      link = home_page.links.find { |l| l.text == name }
puts "#{name} => #{link}"
      link && link.click
#      login unless logged_in?
#      url = URLs[name]
#      agent.get url
    end


    def get_password(prompt: 'pass? ')
      STDIN.getpass(prompt).chomp
    end


    def get_username(prompt: 'user? ')
      printf prompt
      STDIN.gets.chomp
    end


    def home_page
      @home_page ||= login
    end


    def login
      r = agent.post authenticate_url, authentication_credentials, login_headers
      code = r.code.to_i
      @logged_in = code >= 200 && code < 300
      if( logged_in? )
        j = JSON.load r.body
        url = HOST + '/VendorPortal/' + j['forwardUrl']
        agent.get url
      else
        false
      end
    end


    def login_form_page
      @login_form_page ||= agent.get URLs[:login_form]
    end


    def login_form
      login_form_page.forms.first
    end


    def login_headers
      { 'X-CSRF-Token' => csrf_token }
    end


    def pass_field_name
      login_form.fields.last.name
    end


    def read_credentials
      f = File.expand_path( File.join( File.dirname(__FILE__), '..', '..', 'config', 'creds.yml' ) )
      if File.exist? f
        Psych.load_stream(File.read(f)).first
      end
    end


    def user_field_name
      login_form.fields.first.name
    end

  end
end

unless( Module.const_defined? :Portal )
  Portal = NRB::HEBApArPortal
end

unless( Module.const_defined? :HEBApArPortal )
  HEBApArPortal = NRB::HEBApArPortal
end
