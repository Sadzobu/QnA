module Voteable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :voteable, dependent: :destroy
  end

  def upvote(user)
    votes.create(user: user, value: 1) unless voted(user)
  end

  def downvote(user)
    votes.create(user: user, value: -1) unless voted(user)
  end

  def rating
    votes.sum(:value)
  end

  private

  def voted(user)
    votes.exists?(user: user)
  end
end
