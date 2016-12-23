require 'faraday'
#require 'faraday_middleware/parse_oj'
module NRB::HEB::ApArPortal
  class API
    HOST = 'https://avp.heb.com'.freeze

    autoload :LoginHandler, File.join('nrb','heb','ap_ar_portal','api','login_handler')

    include LoginHandler

    def self.host; HOST; end


    def api_call(endpoint: nil)
    end


    def initialize(connection: nil)
      @connection = connection || default_connection
      @logged_in = false
    end

  private


    def default_connection
      Faraday.new(url: HOST) do |faraday|
        faraday.adapter Faraday.default_adapter
        faraday.request :url_encoded
        faraday.response :oj
      end
    end

  end
end
