module Workarea
  module Blog
    class Engine < ::Rails::Engine
      include Workarea::Plugin
      isolate_namespace Workarea::Blog
    end
  end
end
