class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])

  def gist?
    URI(url).host == 'gist.github.com'
  end

  def show_gist
    Octokit::Client.new.gist(url.split('/').last).files.first[1].content
  end
end
