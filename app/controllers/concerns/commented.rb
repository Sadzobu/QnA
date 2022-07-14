module Commented
  extend ActiveSupport::Concern
  included do
    before_action :set_commentable, only: %i[create_comment]
  end

  def create_comment
    @comment = @commentable.comments.create(comment_params.merge(user: current_user))
    render 'comments/create_comment', locals: { comment: @comment }
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_commentable
    @commentable = model_klass.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
