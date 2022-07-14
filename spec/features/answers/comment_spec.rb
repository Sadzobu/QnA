require 'rails_helper'

feature 'Authenticated user can leave comments on answer', %q{
  In order to share my thoughts about answer
  As an authenticated user
  I'd like to be able to leave comments on answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user' do
    scenario 'leaves a comment on answer', js: true do
      sign_in(user)
      visit question_path(question)

      within '.answer_comments' do
        fill_in 'Comment body', with: 'New comment'
        click_on 'Create comment'

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
    scenario "Comment appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.answer_comments' do
          fill_in 'Comment body', with: 'New comment'
          click_on 'Create comment'

          expect(page).to have_content 'New comment'
        end
      end

      Capybara.using_session('guest') do
        within '.answer_comments' do
          expect(page).to have_content 'New comment'
        end
      end
    end
  end
end
