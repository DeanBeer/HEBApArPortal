module NRB
  autoload :HEB, File.join('nrb', 'heb')
  autoload :HTTPService, 'NRB_http_service'

  def self.http_service
    HTTPService
  end

end
