class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: %i[create]
  before_action :load_answer, only: %i[destroy update mark_as_best]
  
  def create
    @answer = @question.answers.create(answer_params)
  end

  def destroy
    @question = @answer.question
    @answer.destroy if current_user.author_of?(@answer)
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def mark_as_best
    @question = @answer.question
    @question.update(best_answer_id: @answer.id) if current_user.author_of?(@question)
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :author_id).with_defaults(author_id: current_user.id)
  end
end
