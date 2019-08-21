module Workarea
  class Content::Blog
    include ApplicationDocument
    include Navigable
    include Contentable
    include Workarea::Releasable
    include Commentable

    field :name, type: String, localize: true
    field :navigation, type: String

    has_many :entries,
             dependent: :destroy,
             class_name: 'Workarea::Content::BlogEntry'

    validates :name, presence: true

    def tags
      if entries.any?
        entries.all_tags.map { |t| t[:name] }
      else
        []
      end
    end
  end
end
