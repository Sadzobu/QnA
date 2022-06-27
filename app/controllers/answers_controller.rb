class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: %i[create destroy]
  
  def create
    @answer = @question.answers.new(answer_params)

    if @answer.save
      redirect_to @question, notice: 'Your answer successfully created.'
    else
      redirect_to @question, alert: 'Your answer was not created!'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to @question
    else
      redirect_to @question, notice: "You can't perform that action"
    end
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :author_id).with_defaults(author_id: current_user.id)
  end
end
