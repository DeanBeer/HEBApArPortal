require 'mechanize'
require 'singleton'

module NRB::HEB::ApArPortal
  class Agent < Mechanize
    include Singleton
    include LoginHandler

    HOST = 'https://avp.heb.com'.freeze
    MECHANIZE_AGENT = AGENT_ALIASES['Mechanize']
    USER_AGENT = 'Windows Chrome'.freeze


    def get(uri, params=[], referer = nil, headers={}, skip_login=false)
      login unless logged_in? || skip_login
      uri = HOST + uri
      super uri, params, referer, headers
    end


    def post(uri, query={}, headers={}, skip_login=false)
      login unless logged_in? || skip_login
      uri = HOST + uri
      super uri, query, headers
    end

  private

    def initialize(*)
      super
      if( user_agent == MECHANIZE_AGENT )
        self.user_agent_alias = USER_AGENT
      end
    end

  end
end
