# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "activerecord-postgres-json"
  gem.version       = "0.0.0"
  gem.authors       = ["mpasternak"]
  gem.email         = ["michal.pasternak@in4mates.pl"]
  gem.description   = %q{postgres json support for active record}
  gem.summary       = %q{postgres json support for active record}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
