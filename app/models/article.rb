class Article < ActiveRecord::Base
  has_many :comments, :as => :commentable
  belongs_to :volume
  belongs_to :collection

  validates_presence_of   :issue_number
  validates_uniqueness_of :slug, :allow_blank => true

  def self.in_volume(number)
    includes(:volume)
      .where("volumes.number = ?", number)
  end

  def self.published
    where(:status => "published")
  end

  def self.drafts
    where(:status => "draft")
  end

  def self.[](key)
    find_by_slug(key) || find_by_id(key)
  end

  def to_param
    if slug.present?
      slug
    else
      id.to_s
    end
  end

  def full_subject
    "Issue #{issue_number}: #{subject}"
  end

  def published?
    status == "published"
  end

  def published_date
    (published_time || created_at).strftime('%Y.%m.%d')
  end
end
