require 'rails_helper'

feature 'Authenticated user can vote for a question', %q{
  In order to express my opinion about a question
  As an authenticated user
  I'd like to be able to vote for a question
} do

  describe 'Authenticated user' do
    scenario "upvotes other user's question" do
      visit questions_path
      within '.questions' do
        
      end
    end
    scenario "downvotes other user's question"
    scenario 'tries to vote on their  question'
    scenario 'can upvote or downvote only once'
    scenario 'can cancel their vote'
  end
end
