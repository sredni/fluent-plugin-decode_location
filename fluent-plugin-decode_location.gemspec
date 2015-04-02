$:.push File.expand_path('../lib', __FILE__)
require 'fluent/plugin/decode_location/version'

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-decode_loaction"
  spec.version       = Fluent::DecodeLocation::VERSION
  spec.authors       = ["L. Srednicki"]
  spec.email         = ["lukasz@sredni.pl"]
  spec.summary       = %q{Fluentd plugin to decode location}
  spec.description   = %q{Fluentd plugin to decode location}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "fluentd"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency "test-unit"
  spec.add_development_dependency "rr"
  spec.add_development_dependency "timecop"
end
