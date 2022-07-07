require 'rails_helper'

feature 'User can edit links in their question', %q{
  In order to change or update links in my question
  As a question's author
  I'd like to be able to edit links
} do

  given(:user) { create(:user) }
  given(:bing_url) { 'https://www.bing.com/' }
  given!(:question) { create(:question, :with_link, author: user) }
  given!(:other_question) { create(:question, :with_link) }

  describe 'Authenticated user' do
    background { sign_in(user) }

    scenario 'edits link on their question', js: true do
      visit questions_path

      within "#question_#{question.id}" do
        click_on 'Edit'
        fill_in 'Link name', with: 'Bing'
        fill_in 'Url', with: bing_url
        click_on 'Save'
        expect(page).to_not have_link 'Bing', href: bing_url
      end
    end

    scenario 'tries to edit link on other user question' do
      visit questions_path

      within "#question_#{other_question.id}" do
        expect(page).to_not have_link 'Edit'
      end
    end
  end

  scenario 'Unauthenticated user tries to edit link' do
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end
end
