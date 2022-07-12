class Answer < ApplicationRecord
  include Voteable
  include Linkable
  
  belongs_to :question
  belongs_to :author, class_name: 'User'

  has_many_attached :files

  validates :body, presence: true

  def best?
    self == question.best_answer
  end
end
