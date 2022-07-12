require 'rails_helper'

feature 'Authenticated user can vote for a answer', %q{
  In order to express my opinion about a answer
  As an authenticated user
  I'd like to be able to vote for a answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:user_answer) { create(:answer, question: question, author: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario "upvotes other user's answer", js: true do
      within "#answer_#{answer.id}_vote" do
        click_on 'Upvote'
      end

      within "#answer_#{answer.id}_rating" do
        expect(page).to have_content '1'
      end
    end

    scenario "downvotes other user's answer", js: true do
      within "#answer_#{answer.id}_vote" do
        click_on 'Downvote'
      end

      within "#answer_#{answer.id}_rating" do
        expect(page).to have_content '-1'
      end
    end

    scenario 'tries to vote on their  answer', js: true do
      within "#answer_#{user_answer.id}" do
        expect(page).to_not have_link 'Upvote'
        expect(page).to_not have_link 'Downvote'
        expect(page).to_not have_link 'Cancel'
      end
    end

    scenario 'can upvote or downvote only once', js: true do
      within "#answer_#{answer.id}_vote" do
        click_on 'Upvote'
        click_on 'Upvote'
      end

      within "#answer_#{answer.id}_rating" do
        expect(page).to have_content '1'
      end
    end

    scenario 'can cancel their vote', js: true do
      within "#answer_#{answer.id}_vote" do
        click_on 'Upvote'
      end

      within "#answer_#{answer.id}_rating" do
        expect(page).to have_content '1'
      end

      within "#answer_#{answer.id}_vote" do
        click_on 'Cancel'
      end

      within "#answer_#{answer.id}_rating" do
        expect(page).to have_content '0'
      end
    end
  end
end
