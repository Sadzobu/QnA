class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :author, class_name: 'User'
  belongs_to :best_answer, class_name: 'Answer', optional: true

  validates :title, :body, presence: true

  def best_answer?
    best_answer != nil
  end

  def other_answers
    answers.where.not(id: best_answer_id)
  end
end
