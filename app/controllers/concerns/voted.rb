module Voted
  extend ActiveSupport::Concern
  included do
    before_action :set_voteable, only: %i[upvote downvote cancel]
  end

  def upvote
    @voteable.upvote(current_user)
    render_json
  end

  def downvote
    @voteable.downvote(current_user)
    render_json
  end

  def cancel
    @voteable.cancel(current_user)
    render_json
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_voteable
    @voteable = model_klass.find(params[:id])
  end

  def render_json
    render json: { resource_name: @voteable.class.name.underscore,
                   resource_id: @voteable.id,
                   rating: @voteable.rating }
  end
end
