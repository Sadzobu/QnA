# frozen_string_literal: true

module Commented
  extend ActiveSupport::Concern
  included do
    before_action :set_commentable, only: %i[create_comment]
    after_action :publish_comment, only: %i[create_comment]
  end

  def create_comment
    @comment = @commentable.comments.create(comment_params.merge(user: current_user))
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

  def question_id
    @commentable.is_a?(Question) ? @commentable.id : @commentable.question.id
  end

  def publish_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast(
      "comments_#{question_id}",
      ApplicationController.render(
        json:
          { comment: @comment.as_json(only: %i[commentable_type commentable_id]),
            html_content: render_to_string(
              partial: 'comments/comment',
              locals: { comment: @comment }
            ) }
      )
    )
  end
end
