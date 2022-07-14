class QuestionsController < ApplicationController
  include Voted

  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :load_question, only: %i[show destroy update]
  after_action :publish_question, only: %i[create]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
    @answer.links.new
  end

  def new
    @question = current_user.questions.new
    @question.links.new
    @question.build_reward
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path
    else
      redirect_to @question, notice: "You can't perform that action"
    end
  end

  def update
    @question.update(question_params)
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
    gon.push({ question_id: @question.id })
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/cquestion',
        locals: { question: @question }
      )
    )
  end

  def question_params
    params.require(:question).permit(:title,
                                     :body,
                                     files: [],
                                     links_attributes: [:id, :name, :url, :_destroy],
                                     reward_attributes: [:id, :title, :file])
  end
end
