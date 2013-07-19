# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "lin/version"

Gem::Specification.new do |spec|
  spec.name          = "lin"
  spec.version       = Lin::VERSION
  spec.authors       = ["Wojciech Wnętrzak"]
  spec.email         = ["w.wnetrzak@gmail.com"]
  spec.description   = %q{Parser for contract bridge board lin notation}
  spec.summary       = %q{lin bridge boards notation parser}
  spec.homepage      = "https://github.com/morgoth/lin"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest", ">= 5.0.0"
end
