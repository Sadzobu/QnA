require 'rails_helper'

feature 'User can delete links added to their answer', %q{
  In order delete wrong link
  As an answer's author
  I'd like to be able to delete links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, :with_link, question: question, author: user) }
  given!(:other_answer) { create(:answer, :with_link, question: question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to delete link on their answer', js: true do
      within "#answer_#{answer.id}" do
        within '.links' do
          click_on 'Delete'
          expect(page).to_not have_link 'Google'
        end
      end
    end

    scenario 'tries to delete link on other user answer' do
      within "#answer_#{other_answer.id}" do
        within '.links' do
          expect(page).to_not have_link 'Delete'
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to delete link on answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete'
  end
end
