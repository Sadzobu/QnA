require 'rails_helper'

feature 'user can edit links in their answers', %q{
  In order to change or update links in my answer
  As an answer's author
  I'd like to be able to edit links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, :with_link, question: question, author: user) }
  given!(:other_answer) { create(:answer, :with_link, question: question) }
  given(:bing_url) { 'https://www.bing.com/' }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits link on their answer' do
      within "#answer_#{answer.id}" do
        click_on 'Edit'
        fill_in 'Link name', with: 'Bing'
        fill_in 'Url', with: bing_url
        click_on 'Save'
        expect(page).to have_link 'Bing', href: bing_url
      end
    end

    scenario 'tries to edit link on other user answer' do
      within "#answer_#{other_answer.id}" do
        expect(page).to_not have_link 'Edit'
      end
    end
  end

  scenario 'Unauthenticated user tries to edit link' do
    visit question_path(question)
    within "#answer_#{answer.id}" do
      expect(page).to_not have_link 'Edit'
    end
  end
end
