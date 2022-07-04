require 'rails_helper'

feature 'User can delete their question', %q{
  In order to remove their question from application
  As an authenticated user
  I'd like to be able to delete a question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit questions_path
    end

    scenario 'tries to delete their question' do
      click_on 'Delete'

      expect(page).to_not have_content question.title
    end

    scenario "tries to delete other user's questions" do
      within "#question_#{question.id}" do
        expect(page).to_not have_selector 'delete-question-link'
      end
    end
  end

  scenario 'Unauthenticated user tries to delete question' do
    visit questions_path

    expect(page).not_to have_link 'Delete'
  end

  describe 'Attachment features' do
    given!(:question) { create(:question, :with_attachment, author: user) }
    given!(:other_question) { create(:question, :with_attachment) }

    scenario 'Authenticated user tries to delete attachment on their question without reloading', js: true do
      sign_in(user)
      visit question_path(question)

      within "#attachment_#{question.files[0].id}" do
        click_on 'Delete'
        expect(current_path).to eq question_path(question)
      end

      expect(page).to_not have_link 'question.files[0].filename.to_s'
    end

    scenario "Authenticated user tries to delete attachment on other user's question" do
      sign_in(user)
      visit question_path(other_question)

      within "#attachment_#{other_question.files[0].id}" do
        expect(page).to_not have_link 'Delete'
      end
    end

    scenario 'Unauthenticated user tries to delete attachment on question' do
      visit question_path(question)

      within "#attachment_#{question.files[0].id}" do
        expect(page).to_not have_link 'Delete'
      end
    end
  end
end
