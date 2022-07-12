class Question < ApplicationRecord
  include Voteable
  include Linkable

  has_many :answers, dependent: :destroy
  has_one :reward, dependent: :destroy
  belongs_to :author, class_name: 'User'
  belongs_to :best_answer, class_name: 'Answer', optional: true

  has_many_attached :files

  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

  def other_answers
    answers.where.not(id: best_answer_id)
  end
end
