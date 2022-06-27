require 'rails_helper'

feature 'User can answer question', %q{
  In order to quickly answer someone's question
  As an authenticated user
  I'd like to be able to write an answer on question's page
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    scenario 'answers a question' do
      sign_in(user)

      visit question_path(question)
      
      fill_in 'answer_body', with: 'Test answer'
      click_on 'Answer'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'Test answer'
    end

    scenario 'answers a question with errors' do
      sign_in(user)

      visit question_path(question)
      
      click_on 'Answer'

      expect(page).to have_content 'Your answer was not created!'
    end
  end

  scenario 'Unauthenticated user tries to answer a question' do
    visit question_path(question)
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end
