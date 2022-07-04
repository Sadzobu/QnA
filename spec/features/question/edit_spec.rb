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
    background do
      sign_in(user)
      visit questions_path
    end

    scenario 'edits their question without loading any new pages', js: true do
      within "#question_#{question.id}" do
        click_on 'Edit'
      end
      
      expect(current_path).to eq questions_path

      within '.questions' do
        fill_in 'Title', with: 'New title'
        fill_in 'Body', with: 'New body'
        click_on 'Save'
        expect(current_path).to eq questions_path

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to_not have_selector 'textarea'
        expect(page).to have_content 'New title'
        expect(page).to have_content 'New body'
      end
    end

    scenario 'tries to edit their question with mistakes', js: true do
      within "#question_#{question.id}" do
        click_on 'Edit'
        fill_in 'Title', with: 'New title'
        fill_in 'Body', with: ''
        click_on 'Save'
      end

      expect(page).to have_content "Body can't be blank"   
    end

    scenario 'tries to edit other user question' do
      within "#question_#{question.id}" do
        expect(page).to_not have_selector 'edit-question-link'
      end
    end

    scenario 'adds files while edititng question', js: true do
      within "#question_#{question.id}" do
        click_on 'Edit'
        fill_in 'Title', with: 'New title'
        fill_in 'Body', with: 'New body'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end

  scenario 'Unauthenticated user tries to edit question' do
    visit questions_path

    expect(page).not_to have_selector 'edit-question-link'
  end
end
