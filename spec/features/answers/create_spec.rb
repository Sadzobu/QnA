require 'rails_helper'

feature 'User can answer question', %q{
  In order to quickly answer someone's question
  As an authenticated user
  I'd like to be able to write an answer on question's page
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'answers a question', js: true do
      fill_in 'answer_body', with: 'Test answer'
      click_on 'Answer'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'Test answer'
      end
    end

    scenario 'answers a question with errors', js: true do
      click_on 'Answer'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'answers a question with attached files', js: true do
      fill_in 'answer_body', with: 'Test answer'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user tries to answer a question', js: true do
    visit question_path(question)

    expect(page).not_to have_selector '.new_answer'
  end

end
