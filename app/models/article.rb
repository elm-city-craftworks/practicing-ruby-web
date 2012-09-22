class Article < ActiveRecord::Base
  has_many :comments, :as => :commentable
  belongs_to :volume
  belongs_to :collection

  validates_presence_of :issue_number

  delegate :body, :to => :document

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

  def full_subject
    "Issue #{issue_number}: #{subject}"
  end

  def published?
    status == "published"
  end

  def published_date
    (published_time || created_at).strftime('%Y.%m.%d')
  end
  
  private

  def document
    Struct.new(:body).new(
      MdPreview::Parser.parse(File.read(Rails.root + "app/documents/#{issue_number}.md")))
  end
end
