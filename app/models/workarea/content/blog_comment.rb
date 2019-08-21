module Workarea
  class Content::BlogComment
    include ApplicationDocument

    field :user_id, type: String
    field :user_info, type: String
    field :body, type: String
    field :pending, type: Boolean, default: true
    field :approved, type: Boolean, default: false

    index(pending: 1)

    validates :user_id, presence: true
    validates :body, length: 10..500

    belongs_to :entry,
               class_name: 'Workarea::Content::BlogEntry',
               inverse_of: :comments,
               index: true

    scope :approved, -> { where(approved: true, pending: false) }
    scope :pending, -> { where(pending: true) }

    delegate :blog, to: :entry
    delegate :name, to: :entry, prefix: true
    delegate :name, to: :blog, prefix: true

    def self.sorts
      [Sort.newest].tap do |sorts|
        sorts.unshift Sort.pending if pending.any?
      end
    end

    def save(*)
      super.tap do |result|
        update_count(result) if result
      end
    end

    def destroy(*)
      super.tap do |result|
        update_count(result) if result
      end
    end

    def approved=(*)
      super.tap do
        self.pending = false
      end
    end

    def author
      return @author if defined?(@author)

      @author = if model = User.where(id: user_id).first
        Workarea::Admin::UserViewModel.new(model)
      end
    end

    private

    def update_count(_result)
      count = entry.comments.approved.count
      entry.set(comment_count: count)
    end
  end
end
