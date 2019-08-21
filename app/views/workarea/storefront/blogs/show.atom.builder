xml.instruct! :xml, version: '1.0'
xml.feed xmlns: 'http://www.w3.org/2005/Atom' do
  xml.title @blog.browser_title
  xml.link rel: 'alternate', type: 'text/html', href: blog_url(@blog)
  xml.link rel: 'self', type: 'application/atom+xml', href: blog_url(@blog, format: 'atom')
  xml.id blog_url(@blog, format: 'atom')
  xml.updated @blog.updated_at.xmlschema if @blog.updated_at.present?

  @blog.entries.each do |entry|
    xml.entry do
      xml.title entry.name
      xml.link rel: 'alternate', type: 'text/html', href: blog_entry_url(@blog, entry)
      xml.published entry.updated_at.xmlschema
      xml.updated entry.updated_at.xmlschema
      xml.author do
        xml.name entry.author
      end

      if entry.summary.present?
        xml.summary type: 'html' do
          xml.cdata! entry.summary
        end
      end
    end
  end
end
