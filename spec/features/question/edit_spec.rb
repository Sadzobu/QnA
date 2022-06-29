require 'rails_helper'

feature 'User can edit their question', %q{
  In order to correct mistakes or update information
  As an authenticated user
  I'd like to be able to edit my question
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:other_question) { create(:question, title: 'Other title', body: 'Other body') }

  describe 'Authenticated user' do
    background { sign_in(user) }

    scenario 'edits their question', js: true do
      visit questions_path

      click_on 'Edit'
      within '.questions' do
        fill_in 'Title', with: 'New title'
        fill_in 'Body', with: 'New body'
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to_not have_selector 'textarea'
        expect(page).to have_content 'New title'
        expect(page).to have_content 'New body'
      end
    end

    scenario 'tries to edit their question with mistakes', js: true do
      visit questions_path
      click_on 'Edit'

      within "#question_#{question.id}" do
        fill_in 'Title', with: 'New title'
        fill_in 'Body', with: ''
        click_on 'Save'
      end

      expect(page).to have_content "Body can't be blank"   
    end

    scenario 'tries to edit other user question' do
      visit questions_path

      within "#question_#{question.id}" do
        expect(page).to_not have_selector 'edit-question-link'
      end
    end
  end

  scenario 'Unauthenticated user tries to edit question' do
    visit questions_path

    expect(page).not_to have_selector 'edit-question-link'
  end
end
