lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'perambulator/version'

Gem::Specification.new do |spec|
  spec.name          = 'perambulator'
  spec.version       = Perambulator::VERSION
  spec.authors       = ['Maddie Schipper']
  spec.email         = ['me@maddiesch.com']

  spec.summary       = 'Perambulator is used for Rails Configuration'
  spec.description   = 'Perambulator is used for Rails Configuration'
  spec.homepage      = 'https://github.com/maddiesch/perambulator'
  spec.license       = 'MIT'

  spec.files         = Dir['{app,config,db,lib}/**/*', 'Rakefile', 'README.md']
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'aws-sdk-kms', '>= 1.0.0', '< 2.0'
  spec.add_dependency 'aws-sdk-ssm', '>= 1.0.0', '< 2.0'
  spec.add_dependency 'hashie',      '>= 3.2.0', '< 4.0'
  spec.add_dependency 'liquid',      '>= 4.0.0', '< 5.0'

  spec.add_development_dependency 'bundler',   '~> 2.0'
  spec.add_development_dependency 'pry',       '~> 0.12'
  spec.add_development_dependency 'rake',      '~> 10.0'
  spec.add_development_dependency 'rspec',     '~> 3.8'
  spec.add_development_dependency 'simplecov', '~> 0.16'
end
