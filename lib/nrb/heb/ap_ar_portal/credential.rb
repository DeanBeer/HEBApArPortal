require 'config_loader'
require 'io/console'

module NRB::HEB::ApArPortal
  class Credential < Struct.new(:user, :pass)

    PASS_KEY = 'j_password'.freeze
    USER_KEY = 'j_username'.freeze

    def self.ask
      new get_username(prompt: "#{USER_KEY}? "),
          get_password(prompt: "#{PASS_KEY}? ")
    end


    def self.default_config_file
      File.expand_path( File.join( File.dirname(__FILE__), '..', '..', '..', '..', 'config', 'creds.yml' ) )
    end


    def self.get_password(prompt: 'pass? ')
      STDIN.getpass(prompt).chomp
    end


    def self.get_username(prompt: 'user? ')
      printf prompt
      STDIN.gets.chomp
    end



    def self.read(filename: nil)
      filename ||= default_config_file
      h = ConfigLoader.new(filename: filename).read
      return unless h
      new h[USER_KEY], h[PASS_KEY]
    end


    def self.read_or_ask(filename: nil)
      c = read(filename: filename)
      return c if c
      ask
    end



    def initialize(*)
      super
      freeze
    end


    def to_h
      { PASS_KEY => pass, USER_KEY => user }
    end


  end
end
