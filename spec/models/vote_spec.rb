require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:voteable) }

  it { should validate_presence_of :value }
end
