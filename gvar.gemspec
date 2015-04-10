lib = File.expand_path('./lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require './lib/g_var/version'

Gem::Specification.new do |spec|
  spec.name          = "gvar"
  spec.version       = GVar::VERSION
  spec.authors       = ["Héctor Valdecantos, Leonardo Matos, Carlos Dubus, Rahul Shinde"]
  spec.email         = ["hvaldecantos@gmail.com"]
  spec.summary       = %q{A gem to observe global variables in C/C++}
  spec.description   = %q{A CLI with multiple functionalities to know more about global variable in a C/C++ project}
  spec.homepage      = ""
  spec.license       = ""

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]   

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'mongo', '~> 2.0'
end
