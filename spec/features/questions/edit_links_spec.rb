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
    background do
      sign_in(user)
    end

    scenario 'edits link on their question', js: true do
      visit questions_path

      within "#question_#{question.id}" do
        click_on 'Edit'
        fill_in 'Link name', with: 'Bing'
        fill_in 'Url', with: bing_url
        click_on 'Save'
      end

      visit question_path(question)
      within '.links' do
        expect(page).to have_link 'Bing', href: bing_url
      end
    end

    scenario 'tries to edit link on other user question' do
      within "#question_#{other_question.id}" do
        expect(page).to_not have_link 'Edit'
      end
    end

    scenario 'adds new link to their question', js: true do
      visit questions_path

      within "#question_#{question.id}" do
        click_on 'Edit'
        click_on 'Add link'
        page.all(:fillable_field, 'Link name')[1].set('Bing')
        page.all(:fillable_field, 'Url')[1].set(bing_url)
        click_on 'Save'
      end

      visit question_path(question)
      within '.links' do
        expect(page).to have_link question.links[0].name, href: question.links[0].url
        expect(page).to have_link 'Bing', href: bing_url
      end
      
    end
  end

  scenario 'Unauthenticated user tries to edit link' do
    visit questions_path

    expect(page).to_not have_link 'Edit'
  end
end
