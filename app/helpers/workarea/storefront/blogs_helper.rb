module Workarea
  module Storefront
    module BlogsHelper
      def blog_posting_schema(entry)
        {
          '@context': 'http://schema.org',
          '@type': 'BlogPosting',
          'url': blog_entry_url(entry),
          'image': entry.thumbnail_image_url.presence,
          'mainEntityOfPage': true,
          'headline': entry.name,
          'dateCreated': entry.created_at.to_date,
          'datePublished': entry.written_at.to_date,
          'dateModified': entry.updated_at.to_date,
          'commentCount': entry.comment_count,
          'keywords': entry.tags,
          'publisher': {
            '@type': 'Organization',
            'name': Workarea.config.site_name,
            'url': root_url,
            'logo': image_url('workarea/storefront/logo.png')
          },
          'author': {
            '@type': 'Person',
            'name': entry.author
          },
          'articleBody': strip_tags(
            render_content_blocks(
              entry.content_blocks_for('blog_content')
            ).html_safe
          ),
          comment: entry.comments.map do |comment|
            {
              '@type': 'Comment',
              'author': comment.user_info,
              'dateCreated': comment.created_at.to_date,
              'text': comment.body
            }
          end
        }
      end
    end
  end
end
