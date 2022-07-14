require 'rails_helper'

feature 'Authenticated user can leave comments on question', %q{
  In order to share my thoughts about question
  As an authenticated user
  I'd like to be able to leave comments on question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    scenario 'leaves a comment on question', js:true do
      sign_in(user)
      visit question_path(question)

      fill_in 'Comment body', with: 'New comment'
      click_on 'Create comment'
      within '.comments' do
        expect(page).to have_content 'New comment'
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to leave a comment on question' do
      visit question_path(question)

      expect(page).to_not have_link 'Create comment'
    end
  end

  describe 'Mulitple sessions' do
    scenario "Comment appears on another user's page"
  end
end
