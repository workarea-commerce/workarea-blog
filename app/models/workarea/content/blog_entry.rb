module Workarea
  class Content::BlogEntry
    include ApplicationDocument
    include Mongoid::Document::Taggable
    include Navigable
    include Contentable
    include FeaturedProducts
    include Workarea::Releasable

    field :name, type: String, localize: true
    field :author, type: String
    field :summary, type: String
    field :comment_count, type: Integer, default: 0
    field :featured, type: Boolean, default: false
    field :written_at, type: DateTime, default: -> { Time.now }
    field :thumbnail_image, type: String

    belongs_to :blog,
               class_name: 'Workarea::Content::Blog',
               index: true

    has_many :comments,
             class_name: 'Workarea::Content::BlogComment',
             inverse_of: :entry

    validates :name, presence: true
    validates :author, presence: true

    scope :newest, -> { desc(:updated_at) }

    def has_thumbnail_image?
      thumbnail_image.present?
    end
  end
end
