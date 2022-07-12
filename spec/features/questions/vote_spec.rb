require 'rails_helper'

feature 'Authenticated user can vote for a question', %q{
  In order to express my opinion about a question
  As an authenticated user
  I'd like to be able to vote for a question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:user_question) { create(:question, author: user) }


  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit questions_path
    end

    scenario "upvotes other user's question", js: true do
      within "#question_#{question.id}_vote" do
        click_on 'Upvote'
      end

      within "#question_#{question.id}_rating" do
        expect(page).to have_content '1'
      end
    end

    scenario "downvotes other user's question", js: true do
      within "#question_#{question.id}_vote" do
        click_on 'Downvote'
      end

      within "#question_#{question.id}_rating" do
        expect(page).to have_content '-1'
      end
    end

    scenario 'tries to vote on their  question', js: true do
      within "#question_#{user_question.id}" do
        expect(page).to_not have_link 'Upvote'
        expect(page).to_not have_link 'Downvote'
        expect(page).to_not have_link 'Cancel'
      end
    end

    scenario 'can upvote or downvote only once', js: true do
      within "#question_#{question.id}_vote" do
        click_on 'Upvote'
        click_on 'Upvote'
      end

      within "#question_#{question.id}_rating" do
        expect(page).to have_content '1'
      end
    end

    scenario 'can cancel their vote', js: true do
      within "#question_#{question.id}_vote" do
        click_on 'Upvote'
      end

      within "#question_#{question.id}_rating" do
        expect(page).to have_content '1'
      end

      within "#question_#{question.id}_vote" do
        click_on 'Cancel'
      end

      within "#question_#{question.id}_rating" do
        expect(page).to have_content '0'
      end
    end
  end
end
