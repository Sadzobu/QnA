require 'rails_helper'

feature 'User can delete their answer', %q{
  In order to remove their answer from question in application
  As an authenticated user and answer's author
  I'd like to be able to delete an answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, :with_attachment, question: question, author: user) }
  given!(:other_answer) { create(:answer, :with_attachment, body: 'Other answer', question: question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to delete their answer without reloading page', js: true do

      within "#answer_#{answer.id}" do
        click_on 'Delete'
      end

      expect(current_path).to eq question_path(question)
      expect(page).to_not have_content answer.body
    end

    scenario "tries to delete other user's answer" do
      within "#answer_#{other_answer.id}" do
        expect(page).to_not have_link 'Delete'
      end
    end
  end

  scenario 'Unauthenticated user tries to delete answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete'
  end

  describe 'Attachment features' do
    scenario 'Authenticated user tries to delete attachment on their answer without reloading', js: true do
      sign_in(user)
      visit question_path(question)

      within "#answer_#{answer.id}" do
        within "#attachment_#{answer.files[0].id}" do
          click_on 'Delete File'
        end
        expect(current_path).to eq question_path(question)
        expect(page).to_not have_link answer.files[0].filename.to_s
      end
    end

    scenario "Authenticated user tries to delete attachment on other user's answer" do
      sign_in(user)
      visit question_path(question)

      within "#attachment_#{other_answer.files[0].id}" do
        expect(page).to_not have_link 'Delete File'
      end
    end

    scenario 'Unauthenticated user tries to delete attachment on answer' do
      visit question_path(question)

      within "#attachment_#{answer.files[0].id}" do
        expect(page).to_not have_link 'Delete File'
      end
    end
  end
end
