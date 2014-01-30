# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_payone'
  s.version     = '1.2.0'
  s.summary     = 'Spree Extenstion for PAYONE'
  s.description = 'Payemnt gateway and methods for PAYONE FinanceGate Server for Spree'
  s.required_ruby_version = '>= 1.8.7'

  s.authors     = ['Maciej Gowin', 'Florian Salis']
  s.email       = 'maciej.gowin@phocus.pl'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency('spree_core',  '~> 2.1.3')
  s.add_development_dependency 'rspec-rails'

end
