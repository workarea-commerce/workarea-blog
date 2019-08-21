Workarea Blog
================================================================================

A Workarea Commerce plugin for creating and managing blogs and blog entries.

Overview
--------------------------------------------------------------------------------

* Creation and management of one or more unique blogs per site
* Utilizes existing content blocks in blog entry creation
* Support for blog Entry Comments & Moderation
* Support for importing from Wordpress

Getting Started
--------------------------------------------------------------------------------

Add the gem to your application's Gemfile:

```ruby
# ...
gem 'workarea-blog'
# ...
```

Update your application's bundle.

```bash
cd path/to/application
bundle
```

Features
--------------------------------------------------------------------------------

### Blogs and Entries vs. Categories and Posts

The workarea blog plugin uses the model 'Blog' as the parent model for
'Entries'.  A site may have many blogs, and a blog may have many entries. This
is similar to the idea of 'Categories' and 'Posts' in other blogging
platforms.

### Commenting and Comment Moderation

Readers are permitted to comment on Blog Entries. Admin users with the proper
permissions may moderate comments left by readers.

### Importing Wordpress Content

The workarea-blog plugin includes a set of rake tasks to import content from
Wordpress blogs. These tasks require an XML export from wordpress, this can be
generated from the Wordpress admin by following the instructions found here:
<https://codex.wordpress.org/Tools_Export_Screen>. Hosted wordpress.com blogs
will have a slightly different interface, but the process is much the same.
You should do a complete export of all data, including attachments, posts, and
pages.

Once you have the XML file downloaded you need to save it in your application.
The import will look for `/data/blog/wordpress.xml` by default, you can
configure the import to use a different path if necessary.

More information below.

Wordpress Import
--------------------------------------------------------------------------------

### Gotchas with importing Wordpress content

All post and page content will be created as an HTML content block. This will
maintain any semantic HTML styles like `<strong>` `<i>` and heading tags.
However, we do not import styles from Wordpress, so any styles coming from
custom classes will not be included. You should set your customer's expectations
around this.  If necessary you could replicate custom styles from wordpress in
your application, or re-write classes as necessary to match classes in the
Workarea application.

Depending on which version of wordpress and which editor was used, some
wordpress posts contain markup that will cause the HTML to be stripped. Before
importing you should look at the `<content:encoded>` fields in the wordpress.xml
and ensure there are no comments that look like this `<!-- wp:paragraph -->`. If
these comments are present you will need to remove them manually.

### Post types for import

Before running the import you should examine the wordpress.xml file, checking
post types. If your Wordpress blog uses custom post types you will need to
customize the import to handle those.

The wordpress import scripts will handle the following post types:

* Attachment - Imported as assets
* Post - Imported as Blog Entries
* Page - Imported as Content Pages

### Import configuration

Before running the import task you should use an initializer to configure the
blog name and author name for all posts coming from Wordpress. If a blog does
not exist with a matching name it will be created. All posts will be attributed
to the same author name, per the configuration.

Default configuration:

```ruby
Workarea.configure do |config|
  config.wordpress_import = {
    'blog_name': 'Wordpress Import',
    'author_name': 'Wordpress User'
  }
end
```

### Running the import

To run the complete import run `bundle exec rake
workarea:blog:import_wordpress`.  This will import attachments, posts, and pages
from the XML file provided. You can also run each of these tasks individually if
necessary. If you opt to do this you *must* run the
`workarea:blog:import_wordpress_attachments` task first as these assets need to
exist before any posts or pages can reference them.

#### Using a different path for import

All import tasks allow a custom path to be used if necessary. The default path
for your wordpress xml export is `/data/blog/wordpress.xml`. To use a different
  path you can pass an argument to the rake task, note that the new path should
  be from your application root directory. Example:

```bash
bundle exec rake workarea:blog:import_wordpress['path/to/your/new_wordpress.xml']
```

WebLinc Platform Documentation
--------------------------------------------------------------------------------

See [https://developer.workarea.com](https://developer.workarea.com) for Workarea Commerce documentation.

License
--------------------------------------------------------------------------------

Workarea Blog is released under the [Business Software License](LICENSE)
