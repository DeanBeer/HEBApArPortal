require 'mechanize'
require 'singleton'

module NRB::HEBApArPortal
  class Agent < Mechanize
    include Singleton

    MECHANIZE_AGENT = AGENT_ALIASES['Mechanize']
    USER_AGENT = 'Windows Chrome'.freeze

    def logged_in?
      @logged_in
    end

  private

    attr_accessor :logged_in

    def initialize(*)
      super
      if( user_agent == MECHANIZE_AGENT )
        self.user_agent_alias = USER_AGENT
      end
      self.logged_in = false
    end

  end
end
