require 'rails_helper'

feature 'User can delete links added to their question', %q{
  In order to delete wrong link
  As a question's author
  I'd like to be able to delete links
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, :with_link, author: user) }
  given!(:other_question) { create(:question, :with_link) }

  describe 'Authenticated user' do
    background { sign_in(user) }

    scenario 'tries to delete link on their question', js: true do
      visit question_path(question)

      within '.links' do
        click_on 'Delete'
        expect(page).to_not have_link 'Google'
      end
    end

    scenario 'tries to delete link on other user question' do
      visit question_path(other_question)

      within '.links' do
        expect(page).to_not have_link 'Delete'
      end
    end
  end

  scenario 'Unauthenticated user tries to delete link on question' do
    visit question_path(question)

    within '.links' do
      expect(page).to_not have_link 'Delete'
    end
  end
end
