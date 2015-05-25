# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ece_prewarmer/version'

Gem::Specification.new do |spec|
  spec.name          = "ece_prewarmer"
  spec.version       = EcePrewarmer::VERSION
  spec.authors       = ["Patricio Bruna"]
  spec.email         = ["pbruna@itlinux.cl"]

  spec.summary       = 'Script para pre-calentar servidores escenic'
  spec.description   = spec.summary
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.require_paths = ["lib"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.add_dependency 'anemone', '~> 0.7'
  spec.add_dependency 'hosts', '~> 0.1'
  spec.add_dependency "bundler", "~> 1.9"

  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "guard", "~> 2.12"
  spec.add_development_dependency "guard-minitest", "~> 2.4"
  spec.add_development_dependency "minitest-reporters", "~> 1.0"
end
