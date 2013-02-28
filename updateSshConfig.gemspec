# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'updateSshConfig/version'

Gem::Specification.new do |spec|
  spec.name          = "updateSshConfig"
  spec.version       = UpdateSshConfig::VERSION
  spec.authors       = ["ma-tar0"]
  spec.email         = ["msa.ota@gmail.com"]
  spec.description   = %q{This library is intended to optimize the ssh config file for AWS}
  spec.summary       = %q{This library is intended to optimize the ssh config file for AWS}
  spec.homepage      = "https://github.com/ma-tar0/aws-updateSshConfig.git"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
