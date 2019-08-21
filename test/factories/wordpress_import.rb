module Workarea
  module Blog
    module Factoris
      module WordpressImport
        Factories.add(self)

        def wordpress_xml_path
          "#{Workarea::Blog.root}/test/fixtures/test_wordpress.xml"
        end

        def wordpress_xml
          File.open(wordpress_xml_path)
        end
      end
    end
  end
end
