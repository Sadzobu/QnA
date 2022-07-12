require 'rails_helper'

shared_examples_for 'voteable' do
  let(:model) { described_class }
  let(:user) { create(:user) }

  it 'calculates rating' do
    entity = create(model.to_s.underscore.to_sym)
    create_list(:vote, 2, voteable: entity)
    expect(entity.rating).to eq(2)
  end

  it 'upvotes' do
    entity = create(model.to_s.underscore.to_sym)
    expect { entity.upvote(user) }.to change { entity.rating }.from(0).to(1)
  end

  it 'downvotes' do
    entity = create(model.to_s.underscore.to_sym)
    expect { entity.downvote(user) }.to change { entity.rating }.from(0).to(-1)
  end
end
