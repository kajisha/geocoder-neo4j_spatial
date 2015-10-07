lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'geocoder/neo4j_spatial/version'

Gem::Specification.new do |spec|
  spec.name          = 'geocoder-neo4j_spatial'
  spec.version       = Geocoder::Neo4jSpatial::VERSION
  spec.authors       = ['kajisha']
  spec.email         = ['kajisha@gmail.com']

  spec.summary       = %q{Geocoder for neo4j_spatial}
  spec.description   = %q{Geocoder for neo4j_spatial}
  spec.homepage      = 'https://github.com/kajisha/geocoder-neo4j_spatial'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'neo4j'
  spec.add_dependency 'geocoder'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
