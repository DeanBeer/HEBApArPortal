# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nrb'

Gem::Specification.new do |spec|
  spec.name          = "nrb-heb-ap_ar_portal"
  spec.version       = NRB::HEB::ApArPortal::VERSION
  spec.authors       = ["Dean Brundage"]
  spec.email         = ["dean@newrepublicbrewing.com"]

  spec.summary       = %q{Write a short summary, because Rubygems requires one.}
  spec.description   = %q{a longer description or delete this line.}
  spec.homepage      = "https://github.com/NewRepublicBrewing/HEBApArPortal"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "guard-rspec"

  spec.add_dependency 'mechanize'

#  spec.add_dependency 'faraday_middleware-parse_oj'
  spec.add_dependency 'simple_config_loader'
#  spec.add_dependency 'NRB_http_service'
end
