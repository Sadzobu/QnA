require 'rails_helper'

feature 'User can answer question', %q{
  In order to quickly answer someone's question
  As an authenticated user
  I'd like to be able to write an answer on question's page
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    scenario 'answers a question', js: true do
      sign_in(user)

      visit question_path(question)
      
      fill_in 'answer_body', with: 'Test answer'
      click_on 'Answer'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'Test answer'
      end
    end

    scenario 'answers a question with errors', js: true do
      sign_in(user)

      visit question_path(question)
      
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to answer a question', js: true do
    visit question_path(question)

    expect(page).not_to have_selector '.new_answer'
  end

end
