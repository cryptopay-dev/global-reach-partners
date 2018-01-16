$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'global_reach_partners/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'global-reach-partners'
  s.version     = GlobalReachPartners::VERSION
  s.authors     = ['Avramov Vsevolod']
  s.email       = ['vsevolod@cryptopay.me']
  s.homepage    = ''
  s.summary     = 'Global Reach Partners API provider'
  s.description = ''
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md', 'holidays.csv']

  s.add_dependency 'activesupport'
  s.add_dependency 'savon', '~> 2.11'
  s.add_dependency 'nokogiri', '~> 1.7'

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rubocop'
end
