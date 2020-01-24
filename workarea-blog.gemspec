$LOAD_PATH.push File.expand_path('../lib', __FILE__)

require 'workarea/blog/version'

Gem::Specification.new do |s|
  s.name        = 'workarea-blog'
  s.version     = Workarea::Blog::VERSION
  s.authors     = ['bcrouse']
  s.email       = ['bcrouse@workarea.com']
  s.homepage    = 'https://github.com/workarea-commerce/workarea-blog'
  s.summary     = 'Blog plugin for Workarea.'
  s.description = 'This plugin adds blogs capability to Workarea.'

  s.files = `git ls-files`.split("\n")

  s.license = 'Business Software License'

  s.add_dependency 'workarea', '~> 3.3.0'
end
