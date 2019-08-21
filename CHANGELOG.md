Workarea Blog 3.4.7 (2019-08-21)
--------------------------------------------------------------------------------

*   Open Source!



Workarea Blog 3.4.6 (2019-06-11)
--------------------------------------------------------------------------------

*   Remove Release Selector When Editing Blog Comments

    Since blog comments are not releasable, remove the current release
    selector from the top of the page which assumes that you're previewing
    content for a future release.

    BLOG-184
    Tom Scott



Workarea Blog 3.4.5 (2019-05-14)
--------------------------------------------------------------------------------

*   Respect Featured Products Sorting In Storefront

    When featured products for a blog entry are sorted in the admin, these
    sorting changes were not reflected on the storefront because of the use
    of `.any_in` rather than `.find_ordered` when querying for products from
    the database. Use `.find_ordered` so that the order of
    `Content::BlogEntry#product_ids` is preserved in the query to MongoDB,
    and the products show up in the correct order when published to the
    storefront.

    BLOG-182
    Tom Scott

*   Fix Comments Timeline Link Text

    The link text for a new comment in the admin activity timeline caused an
    error when Workarea attempted to render the partial, because `#name` is
    not a method on `Content::BlogEntry`. This error has now been fixed by
    updating the text to read from `entry.audited.entry.name` rather than
    `entry.audited.name`.

    BLOG-183
    Tom Scott



Workarea Blog 3.4.4 (2019-04-02)
--------------------------------------------------------------------------------

*   Update wordpress import integration test to only run from the blog plugin source

    BLOG-179
    Jake Beresford

*   Fix WordpressImportIntegrationTest when running in contexts outside of the Blog plugin

    BLOG-179
    Jake Beresford



Workarea Blog 3.4.3 (2019-03-19)
--------------------------------------------------------------------------------

*   Restore Bulk Export / Delete functionality to Blogs

    BLOG-176
    Curt Howard

*   Fix Browsing Control UI Markup

    BLOG-177
    Curt Howard



Workarea Blog 3.4.2 (2019-03-05)
--------------------------------------------------------------------------------

*   Implement SEO Metadata Automation

    The core Workarea platform has a means of automating SEO-related
    metadata (like the browser title and meta description) on content pages
    and product detail pages. This was, however, never implemented in the
    blog plugin even though the help bubbles advertise it do so. Since
    `Content::Blog` models are a separate kind of record which behaves much
    like a `Content::Page`, the blog needs to decorate
    `GenerateContentMetadata` to account for blog models in addition to the
    other contentable records in the system.

    BLOG-139
    Tom Scott

*   Remove Unused Selectors From Blog Entry Styles

    The CSS placeholders for `.blog-entry__share` and
    `.blog-entry__share-heading` have been removed from the `.blog-entry`
    component, since the markup they previously styled has been removed.

    BLOG-174
    Tom Scott



Workarea Blog 3.4.1 (2019-02-05)
--------------------------------------------------------------------------------

*   Update for workarea v3.4 compatibility

    BLOG-175
    Matt Duffy

*   Prevent Mongo Error When Viewing Empty Blog Index

    Check for `blog.entries.any?` before calling `blog.all_tags`, since the
    latter is a map/reduce query that will error if the blog entries
    collection doesn't exist yet.

    BLOG-169
    Tom Scott



Workarea Blog 3.4.0 (2019-01-08)
--------------------------------------------------------------------------------

*   Update README

    Curt Howard

*   Fix test failures when running from host app

    * Use Webmock to stub out image requests instead of VCR
    * Only load rake tasks when running_from_source, this prevents double
    execution of rake tasks in test.

    BLOG-173
    Jake Beresford



Workarea Blog 3.4.0.pre (2018-12-19)
--------------------------------------------------------------------------------

*   Implement Wordpress Import

    * Uses default wordpress XML export
    * Adds raketasks for importing attachments, entries, and pages from wordpress
    * Rewrites all internal img srcs in entries and pages to use updated attachment URLs
    * Adds configration for Blog name and Author Name for imported entries
    * Stores entry content in a single HTML content block
    * Adds Navigation::Redirect for all entries and pages to ensure links still work
    * Updates readme with information baout importing content from Wordpress

    BLOG-168
    Jake Beresford

*   Translate Tag Links in Blog Navigation

    Create a translation for the "$name ($count)" content in the tag links
    sidebar, allowing for easier customization of this text without
    necessarilly overriding the entire `_blog_navigation` partial. An
    example would be changing it to "$name ($count articles)" or something
    of that nature. The quest to remove all hard-coded, non-translatable
    Strings from platform views continues.

    BLOG-170
    Tom Scott

*   Update Gemspec To Require Workarea v3.3.x

    The blog admin attempts to render the `workarea/admin/shared/_bulk_actions`,
    which is not available in Workarea v3.2 and below. Bump the version
    constraint to `>= 3.3.x` to throw an error upon the attempt to bundle
    `workarea-blog` v3.3.x and `workarea` v3.2.x or below.

    BLOG-158
    Tom Scott



Workarea Blog 3.3.2 (2018-09-19)
--------------------------------------------------------------------------------

*   Use the old rubocop because failures

    BLOG-167
    Jake Beresford

*   Update node.trigger to .trigger for headless chrome

    BLOG-167
    Jake Beresford

*   Add missing CI scripts

    nochangelog

    BLOG-167
    Jake Beresford

*   Add missing CI scripts

    BLOG-167
    Jake Beresford

*   * Fix assert_equal should be assert_nil

    BLOG-167
    Jake Beresford

*   Update gemfile to use workarea-ci

    BLOG-167
    Jake Beresford

*   Cleanup gemfile for CI

    Jake Beresford

*   Fix build

    * Compress admin SVGs and remove IDs

    BLOG-167
    Jake Beresford

*   Update blog_navigation markup and classes to match secondary-nav component from base

    This view partial was re-using the base secondary nav component but with incorrect class names and placement, this caused difficulty when applying styles within a theme or host application. Updated the view to match base component structure.

    BLOG-166
    Jake Beresford

*   Add opengraph metadata to blog entries

    * Adds og meta tags for type, title, and URL to blog_entry#show

    BLOG-152
    Jake Beresford

*   Update size of slug fields

    * Makes slug text boxes slightly larger, matching other slug inputs in the admin

    BLOG-131
    Jake Beresford

*   Update blog entry seed data

    * Use a pre-defined list for entry titles instead of Faker::Books which was producing some... interesting titles

    BLOG-130
    Jake Beresford

*   Render direct to page CSS and JS on blog entry pages

    BLOG-155
    Jake Beresford

*   Fix test from bad merge

    Ben Crouse

*   Revert "Enable Workarea CI"

    This reverts commit 48bcc349296c9aae538c7b60f8392ec17d5b3a77.
    Curt Howard

*   Revert "Enable Workarea CI"

    This reverts commit 48bcc349296c9aae538c7b60f8392ec17d5b3a77.
    Curt Howard

*   Revert "Enable Workarea CI"

    This reverts commit 48bcc349296c9aae538c7b60f8392ec17d5b3a77.
    Curt Howard

*   Fix Gemfile

    Curt Howard



Workarea Blog 3.3.1 (2018-08-21)
--------------------------------------------------------------------------------

*   Fix megabuild. No changelog.

    Tom Scott

*   Fix test from bad merge

    Ben Crouse

*   Share blog entry thumbnail images on social media

    When sharing blog entries on LinkedIn, Facebook, or Instagram (basically
    anything that pays attention to open graph tags), images were not
    appearing because the `og:image` meta tag was never specified. Set this
    to the blog entry's thumbnail image URL so images will appear properly
    on social media and other communities.

    BLOG-161
    Tom Scott

*   View blog entries when previewing release

    Previously, release previews didn't include blog entries because of the
    way we return these models from MongoDB. We're now detecting whether the
    release is being previewed, and if so, we're retrieving _all_ entries
    and filtering them by whether the user is active or not.

    BLOG-88
    Tom Scott

*   Prevent duplicate ID errors in admin

    * Remove IDs from SVG icons
    * Compress SVG icons using SVGO
    * Fix duplicate IDs in blog entry content field view
    * Default blog entry on content block is empty string to prevent errors

    BLOG-148
    Jake Beresford

*   Fix broken blog entry thumbnails on blogs index

    * Blog entries on blogs index page must be wrapped in the BlogEntryViewModel
    * Update view to reference thumbnail_image_url method from BlogEntryViewModel
    * Resolve same issue with featured_entry content block not using BlogEntryViewModel

    BLOG-144
    Jake Beresford

*   Add component stylesheet for featured entry content block

    * Create a blank stylesheet with all component selectors
    * Append new stylesheet
    * Remove redundant classes from content block view
    * Update featured-entry-content-block__content to use short haml notation

    BLOG-146
    Jake Beresford

*   Fix typo, change appeds.rb to appends.rb

    BLOG-147
    Jake Beresford

*   Remove use of deprecated Sass functions

    * Halve and double functions were removed in v3, update Sass to use regular math

    BLOG-145
    Jake Beresford

*   Add expected route used for blog entry content block autofill

    BLOG-140
    Matt Duffy



Workarea Blog 3.3.0 (2018-05-24)
--------------------------------------------------------------------------------

*   Update rubocop & fix offenses

    BLOG-153
    Jake Beresford

*   Correct content area name on blog/show

    BLOG-153
    Jake Beresford

*   Support Bulk Action Items UI

    ECOMMERCE-6012
    Curt Howard

*   Add importing/exporting from base v3.3

    ECOMMERCE-6010
    Ben Crouse

*   Leverage Workarea Changelog task

    ECOMMERCE-5355
    Curt Howard

*   Fix for headless Chrome

    Ben Crouse



Workarea Blog 3.2.0 (2018-02-06)
--------------------------------------------------------------------------------

*   Fix missing i18n key in blog entry content block

    The placeholder text was using the wrong translation key, it's now using the correct one.

    BLOG-137
    Tom Scott

*   Update featured entry content block optionally feature most recent posts

    * Add option to automatically feature recent posts
    * Allow multiple posts to be featured in a single block
    * Add blog_id ContentField
    * Remove search form button from blog_entires ContentField as it was causing other fields to be unusable
    * Re-write blog_entry_id and blog_id ContentFields to use remote_select admin module
    * Remove now redundant autocomplete_autofill JS module from plugin, replaced by remote_select.js
    * Add tests for new content block view model functionality
    * Add system tests for blog entry content block

    BLOG-149
    Jake Beresford

*   Allow admin user to edit blog entry URL

    * Add slug field to content_blog_entry#edit view

    BLOG-142
    Jake Beresford

*   Update blog metadata

    * Adds markup for publisher metadata to blog entry and blog entry summary views via a shared _publisher.html.haml view partial.
    * Publisher markup does not include logo metadata because we would need a logo image helper to dynamically update height and width values sitewide.
    * Ensure image is made available to schema if thumbnail is available.
    * Use blog_entry summary view partial on blogs index page to reduce duplicate markup and ensure consistency.
    * Ensure all blog entry views pass google's structured data testing tool when relevant data is all present.

    BLOG-105

    Remove logo metadata from publisher, replace with TODO

    BLOG-105
    Jake Beresford

*   Prevent duplicate ID errors in admin

    * Remove IDs from SVG icons
    * Compress SVG icons using SVGO
    * Fix duplicate IDs in blog entry content field view
    * Default blog entry on content block is empty string to prevent errors

    BLOG-148
    Jake Beresford

*   Make it easier to link to blogs and blog entries inthe navigation

    * Add Navigable Types for blog and blog_entry
    * Add blog and blog_entry to SetNavigable
    * Decorate taxon_icon helper to add conditions for blog and blog_entry icons
    * Re-write autocomplete_autofill module to use select2 since this uses the same endpoint as taxon remote select. The previous implementation using jQueryUI autofill required the JSON to be structured differently which caused an issue in the content block admin UI - blog entry ID was displayed instead of name.
    * Update blog seeds to include blogs index at the root with 3 blogs as it's children. Add taxonomy content block to show seeded blogs in drop-down navigation

    BLOG-143
    Jake Beresford

*   Fix broken blog entry thumbnails on blogs index

    * Blog entries on blogs index page must be wrapped in the BlogEntryViewModel
    * Update view to reference thumbnail_image_url method from BlogEntryViewModel
    * Resolve same issue with featured_entry content block not using BlogEntryViewModel

    BLOG-144
    Jake Beresford

*   Add component stylesheet for featured entry content block

    * Create a blank stylesheet with all component selectors
    * Append new stylesheet
    * Remove redundant classes from content block view
    * Update featured-entry-content-block__content to use short haml notation

    BLOG-146
    Jake Beresford

*   Fix typo, change appeds.rb to appends.rb

    BLOG-147
    Jake Beresford

*   Remove use of deprecated Sass functions

    * Halve and double functions were removed in v3, update Sass to use regular math

    BLOG-145
    Jake Beresford

*   Convert index summaries to tables

    BLOG-141
    Curt Howard


Workarea Blog 3.1.0 (2017-09-15)
--------------------------------------------------------------------------------

*   Add expected route used for blog entry content block autofill

    BLOG-140
    Matt Duffy

*   Fix 500 error on atom feed

    Update atom feed to use local instead of instance var

    BLOG-136
    Tom Scott

*   Update trash behavior, fix test issues

    BLOG-135
    Matt Duffy

*   Add restore links to blog activity, remove dependent destroy on blog and entries

    BLOG-135
    Matt Duffy

*   Better Seed Data

    Seed data for blog titles is now static.

    The titles being generated by Faker were often problematic in demo
    situations, because book titles don't always make good blog titles.
    In lieu of Faker, the new seed data includes three static titles
    that pun on fashion terminology.

    BLOG-134
    Matt Dunphy


Workarea Blog 3.0.2 (2017-07-25)
--------------------------------------------------------------------------------

*   Fix 500 error on atom feed

    Update atom feed to use local instead of instance var

    BLOG-136
    Tom Scott

*   Hook up advanced content fields: browser_title and meta description for blog_entries

    BLOG-104
    Jake Beresford

*   Remove jshint and replace with eslint BLOG-129
    Dave Barnow


Workarea Blog 3.0.1 (2017-07-07)
--------------------------------------------------------------------------------

*   Hook up advanced content fields: browser_title and meta description for blog_entries

    BLOG-104
    Jake Beresford

*   Remove jshint and replace with eslint BLOG-129
    Dave Barnow


Workarea Blog 3.0.0 (2017-05-18)
--------------------------------------------------------------------------------

*   Hide useless facets or the blog id facet

    no reason to show the blog id facet because it provides no value to the
    admin user.

    BLOG-128
    Eric Pigeon

*   Clean up tests

    no changelog

    BLOG-118
    Eric Pigeon

*   Fix parameter key to match what route is setting

    The parameter key was being sent as content_blog_entry_id but
    controllers and view models were using blog_entry_id

    BLOG-127
    Eric Pigeon

*   Normalize admin navigation within blog resources

    BLOG-126
    Beresford, Jake

*   Blog index content QA fixes

    * Correct naming of blog index content area in seed
    * Add new area to content_areas config

    BLOG-123
    Beresford, Jake

*   Remove tags from blog card following QA feedback.

    Since tags are aggregated from all entries in a blog and are not editable it doesn't make sense to display them on the card.

    BLOG-125
    Beresford, Jake

*   Update blog index page for QA feedback

    * remove legacy sort no-js button
    * put the pagination at the bottom of results
    * drop vertical line to the right of sort

    BLOG-124
    Beresford, Jake

*   Upgrade blog for workarea v3 compatibility

    * Update all admin views for blog
    * Add translations for admin blog views & translate JS
    * Blog thumbnail uses content asset picker
    * fixes bugs with deleting blogs and entries
    * fixes some junk in the activity views
    * Converted seed data to new format
    * Created store front partial for blog entry summary
    * Added a workflow for blog entry creation
    * Removed blog_entry#new view - replaced by workflow
    * Remove legacy content area views, add blog content area to engine and rename.
    * Updated blog entry content block type, added blog_entry_id content field type
    * Update storefront views with global ID for admin toolbar
    * Remove redundant breadcrumb definitions
    * Add some page titles where they were previously missing
    * All specs converted to tests
    * Removes spec directory including spec/dummy
    * Cleanup rubocop, add bin/rails, update test/dummy/config/application

    BLOG-118
    Beresford, Jake


WebLinc Blog 2.1.2 (2017-03-28)
--------------------------------------------------------------------------------

*   Force .json type in /admin/content_blogs request

    When the `Navigation::Link` form tries to find blogs to link to as the
    Linkable, it fails because we are requesting `/admin/content_blogs` and
    the response defaults to HTML. With this change, we'll be requesting
    `/admin/content_blogs.json` and forcing the response type to be JSON.

    BLOG-119
    Tom Scott

*   Correct some incorrect microdata using google's "structured microdata testign tool".

    BLOG-105
    Beresford, Jake

*   Update Microdata for blog.

    Added or changed schema itemprops where necessary to provide the orrect microdata structure for blog entries and summaries of entries on index pages.

    * author, datePublished, headline, and image were the main props that had to be added or adjusted in some way
    * Also changed the element type for all entries to use <article> for better semantics
    * Improve some semantics by adding <heading> elements to entry summaries and moving the blog thumbnails below other important information.
    * Fixed rubocop failures on bamboo

    BLOG-105
    Beresford, Jake


WebLinc Blog 2.1.1 (2017-01-04)
--------------------------------------------------------------------------------

*   Add minlength to blog comment input. This enables client-side validation messaging which is much clearer for the user.

    BLOG-116
    Beresford, Jake


WebLinc Blog 2.1.0 (2016-10-12)
--------------------------------------------------------------------------------

*   Don't try to test activity if that functionality isn't present

    This is for v2.3 _and_ earlier version compatibility.

    BLOG-114
    Ben Crouse

*   Clear driver cache when hitting same page within spec

    BLOG-113
    Matt Duffy

*   Add activity support for v2.3

    BLOG-114
    Ben Crouse


WebLinc Blog 2.0.1 (2016-08-17)
--------------------------------------------------------------------------------

*   Fetch comments and comment form via ajax to avoid caching blog entry comments

    BLOG-103
    Matt Duffy


WebLinc Blog 2.0.0 (2016-08-01)
--------------------------------------------------------------------------------

*   Added tests for comment count

    BLOG-102

    fix
    Beresford, Jake

*   Allow approving blog comments without reordering posts

    Approving a comment on an older post will currently
    bring that post to the top of the store front blog
    section by modifying the updated_at attribute.

    Since blogs are ordered by updated_at, use set to
    prevent this from changing.
    Use Sanrio commit f01e5673111

    BLOG-102
    Kristen Ward

*   Added tests for comment count

    BLOG-102

    fix
    Beresford, Jake

*   Allow approving blog comments without reordering posts

    Approving a comment on an older post will currently
    bring that post to the top of the store front blog
    section by modifying the updated_at attribute.

    Since blogs are ordered by updated_at, use set to
    prevent this from changing.
    Use Sanrio commit f01e5673111

    BLOG-102
    Kristen Ward

*   Adds blog index view

    * Displays top x posts for each blog instance, number of posts can be set by config.
    * Blog index page is contentable
    * Blog index page content is linked in admin menu

    BLOG-93
    Beresford, Jake

*   Move featured entry compound property inside section for alignment

    BLOG-100
    Beresford, Jake

*   Add missing translation key for byline

    BLOG-94
    Beresford, Jake

*   Added sample data for blogy entry summary

    * Updated Faker to use Hipster because Lorem is annoying when testing

    BLOG-99
    Beresford, Jake

*   Add rubocop config and update code style to pass rubocop

    * Fixed all spec failures

    BLOG-98
    Beresford, Jake

*   Add date written to blog entries for display and sorting.

    * Adds a new DateTime field to blog_entry
    * Change blog index sort to use this date field, instead of updated_at
    * Displays date written on store front views

    BLOG-91
    Beresford, Jake

*   Add featured entry content block.

    * adds a search controller action and route to blog_entries
    * adds autocomplete_autofill module to populate a specified field with a value returned in autocomplete JSON response
    * Uses search to find blog entry by name
    * Stores Blog entry ID in content_block
    * View model used to find blog entry and blog record then display content

    BLOG-94
    Beresford, Jake

*   Correct sort order of featured and updated at

    BLOG-90
    Beresford, Jake

*   Adds a content area for blog_header, renames content block areas to be more descriptive

    BLOG-92
    Beresford, Jake

*   Fix blog comment inconsistencies

    Change menu link to say 'Blog Entry Comments' to match page
    header on click-through.
    Add comments display/notification to context menu on blog edit page

    BLOG-97
    Kristen Ward

*   Change blog entry summary to a string.

    *Remove the contentable area for blog entry summary and add a string to the model.
    *Adds a text area to the admin views.
    *Renders the summary string in place of the content area.

    BLOG-89
    Beresford, Jake

*   Adds ability to feature a blog entry.

    * Admin users can mark an entry as featured
    * Featured blog entries will be sorted to the top of the blog index
    * A class is added to the blog entry summary to allow SIs to provide
    different styles for featured entries

    BLOG-90
    Beresford, Jake

*   Allow admin comments/discussion on blogs

    Admin commenting on blogs does not work due to a naming
    conflict with "blog comments" as seen on the store front.
    Give user comments on blog items a named resource so that
    both admin comments and user comments can exist.

    BLOG-65
    Kristen Ward

*   Update blog comments to show original post time

    Blog comments are showing updated at time. Change to date and
    time comment was first posted.

    BLOG-68
    Kristen Ward

*   Add author name display to entry and entry summary

    Author is not displaying on front end. Add to index view and
    to entry show view.

    Add default styles to fit with existing

    BLOG-70
    Kristen Ward

*   Remove pending from sort options if no pending comments

    Dropdown defaults to pending even when there are no pending comments.
    Remove this sort option when unnecessary.

    BLOG-74
    Kristen Ward

*   Display only tags for active blog entries in store front side nav

    Side navigation shows all tags for a blog, even when tag only
    corresponds to an inactive entry.

    Update view model method to include only active entries' tags

    BLOG-80
    Kristen Ward

*   Update icon--check-mark to icon--system-success

    After the check-mark icon was renamed to have a more generic use case,
    some of the markup wasn't updated to match the new name. This fixes this
    issue.

    BLOG-82
    Curt Howard

*   Fix blog entry release changes display

    Changeset partial is being called incorrectly, resulting in errors.
    Make call to partial more explicit.

    BLOG-78
    Kristen Ward

*   BLOG-73: displaying related products on the store_front
    Steve Perks

*   Fix blog comment sorting

    Attempting to sort blog comments causes all results
    for blog comments to display.

    Add the blog entry id param to the sort form if present
    Update admin spec to verify correct behavior on sort

    BLOG-64
    Kristen Ward


WebLinc Blog 1.0.1 (February 20, 2016)
--------------------------------------------------------------------------------

*   Output related products in Store Front

    BLOG-73

*   Fix blog comment sorting

    Attempting to sort blog comments causes all results
    for blog comments to display.

    Add the blog entry id param to the sort form if present
    Update admin spec to verify correct behavior on sort

    BLOG-64


WebLinc Blog 1.0.0 (January 14, 2016)
--------------------------------------------------------------------------------

*   Render 404 if an entry isn't active

    BLOG-71

*   Fix blog entries throwing routing error as search results

    This is fixed by removing the blog scoping for entry routes. After changing
    that, blog entries conform to the same standards to routing as other
    resources in the store front.

    BLOG-76

*   Update for compatibility with WebLinc 2.0

*   Replace absolute URLs with relative paths


WebLinc Blog 0.11.0 (October 6, 2015)
--------------------------------------------------------------------------------

*   Update blog to be compatible with v0.12

    Update new & edit views, property work
    Add blank row to permissions partial
    Update indexes, add context-menu to summary/edit

    BLOG-63

*   Update token-fields to become remote-selects.

    Fix linkable_types array for use with navigation#edit.

    Remove params whitelist from `content_blog_entries_controller`.

    BLOG-63

*   Add link depth css modifiers to blog admin menu

    BLOG-58


WebLinc Blog 0.10.0 (August 21, 2015)
--------------------------------------------------------------------------------

*   Change weblinc version constraint to '~> 0.11.0'.

    81d6ac445d866b79cc7ebc7308f1467bfcbde24d

*   Replace publishing with releasing.

    8d707e6bfb4778af2c15281b1440a114fe98a01d
    0f1b671d9200edade0ff371ddb7d3874e5cff5d1

*   Rename SCSS blocks `panel` and `panel--buttons` to `index-filters` and
    `form-actions`, respectively, for compatibility with WebLinc 0.11.

    368a0706f2d48cdf3a715812c1dbe45523767cd3

    BLOG-57

*   Update view models for compatibility with WebLinc 0.11.

    fc96cedf4264554dfefb5f6dc25709158527fe67

*   Make blog entries releasable.

    d24155a1a6f8e9eb22148b23e8c7aef588417ce3
    f9bb4f0d38997487ed45db85570b8ebf2fac04cd
    3b5c22924beb93961d69cef71429b9a3aa04d370

*   Localize blog names and blog entry names.

    6a672dadb022851a8916c664c45848a1d6a1d2ca

*   Redirect to edit content path after create new blog entry.

    BLOG-56

    5deb435e5246b812acf2e3f22c52e9350add7585 (merge)

*   Fix selected navigation nodes in blog entry Admin views.

    eb48c3a75d0c589c1b15ba80f1a77e8cea91213f


WebLinc Blog 0.9.0 (July 11, 2015)
--------------------------------------------------------------------------------

*   Update for compatibility with weblinc 0.10.0.

    04744c3d2ee9578d3f23016e406c4eb25107f12f
    0bd3553a4438b5a76d3fe7313ba8fab25c8b0bd5
    c10dde5dbe31cdfe8451cae084ba3dc3666fe228
    a60c5d4c3ca10ea96df6fe388cff831e5c75ccdb (merge)

*   Remove trailing period from blog titles.

    BLOG-45

    1336e9c1122fc12b43afc1c73f18effaad23597a

*   Clean up model summaries.

    BLOG-53

    26ae48a43f309232c3e48cb323f6b9bbe45e2a73
    07a5ee857ca5d1726005848e49409c751c234cba

*   Remove unnecessary `view__header` elements.

    BLOG-54

    34c01cacf10b9a2fb79c6cf538bb5daf5594ba1e

*   Fix "back" buttons in Admin.

    BLOG-52

    1ffb08432b4865452c3d71b2398dbba929943cf3

*   Update `selected_navigation_nodes` in Admin.

    BLOG-51

    9fc9bdef949eea6f83ab4bafede43249dc9b78b1


WebLinc Blog 0.8.0 (June 1, 2015)
--------------------------------------------------------------------------------

*   Rename fixtures to factories and clean up factories.

*   Update for compatibility and consistency with weblinc 0.9.0.

*   Fix blog comment count.

    BLOG-38

*   Fix link to blog comments so that it shows comments on that blog only.

    BLOG-39

*   Remove buggy clear filters feature.

    BLOG-30

*   Validate presence of `BlogEntry#publish_at`.

    BLOG-35

*   Fix inability to delete blog comment.

    BLOG-37


WebLinc Blog 0.7.0 (April 10, 2015)
--------------------------------------------------------------------------------

*   Update testing environment for compatibility with WebLinc 0.8.0.

*   Use new decorator style for compatibility with WebLinc 0.8.0.

*   Remove gems server secrets for compatibility with WebLinc 0.8.0.

*   Update assets for consistency with WebLinc 0.8.0.
