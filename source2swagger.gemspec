# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.name          = "source2swagger"

  gem.authors       = ["Josep M. Pujol"]
  gem.email         = 'josep@3scale.net'

  gem.description   = %q{Tool for converting comments to Swagger JSON specification}
  gem.summary       = %q{Builds a swagger compliant JSON specification from annotations on the comments of your source code.}

  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.version       = '0.0.1'

  gem.add_dependency 'json'
end
