require 'rails_helper'
require 'models/concerns/voteable_spec'

RSpec.describe Answer, type: :model do
  it_behaves_like 'voteable'

  it { should belong_to(:question) }
  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it { should have_many(:votes).dependent(:destroy) }

  it 'has many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
