$LOAD_PATH.push File.expand_path('../lib', __FILE__)

require 'workarea/blog/version'

Gem::Specification.new do |s|
  s.name        = 'workarea-blog'
  s.version     = Workarea::Blog::VERSION
  s.authors     = ['bcrouse']
  s.email       = ['bcrouse@workarea.com']
  s.homepage    = 'https://github.com/workarea-commerce/workarea-blog'
  s.summary     = 'Blog plugin for the Workarea Commerce Platform'
  s.description = 'This plugin adds blogs functionality to the Workarea Commerce Platform.'

  s.files = `git ls-files`.split("\n")

  s.license = 'Business Software License'

  s.add_dependency 'workarea', '~> 3.x', '>= 3.5.x'
end
