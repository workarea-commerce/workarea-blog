require 'webmock/minitest'

module Workarea
  module Blog
    module StubWordpressAssets
      extend ActiveSupport::Concern

      included { setup :stub_wordpress_assets }

      def stub_wordpress_assets
        stub_request(:get, 'https://testingwordpressexports.files.wordpress.com/2018/11/person-smartphone-office-table.jpeg')
          .to_return(body: 'abc', headers: { 'Content-Type': /image\/.+/ })

        stub_request(:get, 'https://testingwordpressexports.files.wordpress.com/2018/11/person-smartphone-office-table2.jpeg')
          .to_return(body: 'abc', headers: { 'Content-Type': /image\/.+/ })
      end
    end
  end
end
