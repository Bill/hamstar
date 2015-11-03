# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hamstar/version'

Gem::Specification.new do |spec|
  spec.name          = "hamstar"
  spec.version       = Hamstar::VERSION
  spec.authors       = ["Bill Burcham"]
  spec.email         = ["bill.burcham@gmail.com"]
  spec.summary       = %q{Hamstar Transforms Immutable Ruby Collections Better}
  spec.description   = %q{Hamstar.update_having() lets you transform deep amalgamations of Hamster (immutable) Hash and Vector with all the features of update_in() plus: associative selection [key,val], Kleene star '*', and generalized Proc-based matching}
  spec.homepage      = "https://github.com/Bill/hamstar"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'hamster', '~> 2'

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
