require 'test_helper'

module Workarea
  module Blog
    class WordpressImportIntegrationTest < Workarea::IntegrationTest
      def test_creates_all_objects
        return unless running_from_source?
        Rails.application.load_tasks
        Rake::Task['workarea:blog:import_wordpress'].invoke(wordpress_xml_path)

        entries = Workarea::Content::BlogEntry.all
        assert(entries.present?)
        assert_equal(4, entries.count)
        assert_equal(Workarea.config.wordpress_import[:blog_name], entries.first.blog.name)

        pages = Workarea::Content::Page.all
        assert(pages.present?)
        assert_equal(2, pages.count)

        assets = Workarea::Content::Asset.all
        assert(assets.present?)
        assert_equal(2, assets.count)
      end
    end
  end
end
