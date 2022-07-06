require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:gist_url) { 'https://gist.github.com/Sadzobu/a4f6dc257c2b0f00b8204f2c738a0d31' }
  given(:google_url) { 'https://www.google.ru/' }

  background do
    sign_in(user)
    visit question_path(question)

    fill_in 'answer_body', with: 'My answer'
  end

  scenario 'User adds link when asks question', js: true do
    page.all(:fillable_field, 'Link name')[0].set('My gist')
    page.all(:fillable_field, 'Url')[0].set(gist_url)
    click_on 'Add link'
    page.all(:fillable_field, 'Link name')[1].set('Google')
    page.all(:fillable_field, 'Url')[1].set(google_url)
    click_on 'Answer'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
      expect(page).to have_link 'Google', href: google_url
    end
  end

  scenario 'User adds invalid link', js: true do
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: 'wrong_url'
    click_on 'Answer'

    expect(page).to have_content 'Links url is invalid'
  end
end
