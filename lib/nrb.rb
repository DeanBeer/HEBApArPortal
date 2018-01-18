module NRB
  autoload :HEB, File.join('nrb', 'heb')
  autoload :FromJSONHash, File.join('nrb', 'from_json_hash')
  autoload :HTTPService, 'NRB_http_service'

  def self.http_service
    HTTPService
  end

end
