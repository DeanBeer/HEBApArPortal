require_relative 'ap_ar_portal/version'
require 'io/console'
require 'json'
require 'yaml'

module NRB::HEB
  module ApArPortal

    extend self

    HOST = 'https://avp.heb.com'.freeze

    URLs = { login_form: HOST + '/VendorPortal/loginPage',
             invoice: HOST + '/VendorPortal/secure/search/invoice',
             payment: HOST + '/VendorPortal/secure/search/detail/Payment/false',
             payments: HOST + '/VendorPortal/secure/search/payment',
             search: HOST + '/VendorPortal/secure/homePage?execution=e1s2',
           }

    VENDOR_NUM = "09121406".freeze

    autoload :Agent, File.join('nrb', 'heb', 'ap_ar_portal', 'agent')

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

    attr_accessor :password, :username

    def agent(debug: true)
      a = Agent.instance
      if( debug )
        a.log = debug.is_a?(Logger) ? debug : default_logger
      end
      a
    end


    def ask_credentials
      {
        user_field_name => get_username(prompt: "#{user_field_name}? "),
        pass_field_name => get_password(prompt: "#{pass_field_name}? ")
      }
    end


    def authentication_credentials
      @authentication_credentials ||= (read_credentials || ask_credentials)
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


    def format_date(date)
      self.class.format_date date
    end


    def get(*args)
      login unless logged_in?
      agent.get *args
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


    def invoice_params(num:, start:, stop:)
      {
        "sEcho"=>"2",
        "iColumns"=>"14",
        "sColumns"=>"",
        "iDisplayStart"=>"0",
        "iDisplayLength"=>"25",
        "amDataProp"=>"invoiceSequenceId",
        "sSearch"=>"",
        "bRegex"=>"false",
        "asSearch"=>"",
        "abRegex"=>"false",
        "abSearchable"=>"true",
        "iSortingCols"=>"0",
        "abSortable"=>"true",
        "vendorNumber"=> VENDOR_NUM,
        "allVendorNumbers"=>"false",
        "invoiceNumber"=> num,
        "dateBegin"=> start,
        "dateEnd"=> stop
      }
    end


    def logged_in?
      !! @logged_in
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


    def payments_params(start:, stop:)
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
        "vendorNumber"=> VENDOR_NUM,
        "dateBegin"=> start,
        "dateEnd"=> stop
      }
    end


    def read_credentials
      f = File.expand_path( File.join( File.dirname(__FILE__), '..', '..', '..', 'config', 'creds.yml' ) )
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
  Portal = NRB::HEB::ApArPortal
end

unless( Module.const_defined? :ApArPortal )
  ApArPortal = NRB::HEB::ApArPortal
end
