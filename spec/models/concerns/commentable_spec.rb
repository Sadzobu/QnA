require 'rails_helper'

shared_examples_for 'commentable' do
  let(:model) { described_class }

  it 'creates_comment' do
    entity = create(model.to_s.underscore.to_sym)
    comment = create(:comment, commentable: entity)
    expect(entity.comments.last).to eq(comment)
  end
end
