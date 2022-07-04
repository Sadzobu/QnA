require 'rails_helper'

feature 'User can edit their answer', %q{
  In order to correct mistakes or update information
  As an authenticated user
  I'd like to be able to edit my answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given!(:other_answer) { create(:answer, body: "Other user answer", question: question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits their answer without loading any new pages', js: true do
      within "#answer_#{answer.id}" do
        click_on 'Edit'
        expect(current_path).to eq question_path(question)
        fill_in 'Your answer', with: 'New body'
        click_on 'Save'
        expect(current_path).to eq question_path(question)

        expect(page).to_not have_content answer.body
        expect(page).to_not have_selector 'textarea'
        expect(page).to have_content 'New body'
      end
    end

    scenario 'tries to edit their answer with errors', js: true do
      within "#answer_#{answer.id}" do
        click_on 'Edit'

        fill_in 'Your answer', with: ''
        click_on 'Save'
      end
      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's answer" do
      within "#answer_#{other_answer.id}" do
        expect(page).to_not have_selector 'edit-answer-link'
      end
    end

    scenario 'adds files while editing answer', js: true do
      within "#answer_#{answer.id}" do
        click_on 'Edit'
        fill_in 'Your answer', with: 'New body'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end

  scenario 'Unauthenticated user tries to edit answer' do
    visit question_path(question)

    expect(page).not_to have_selector 'edit-answer-link'
  end

end
