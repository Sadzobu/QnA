require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As a question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/Sadzobu/a4f6dc257c2b0f00b8204f2c738a0d31' }
  given(:google_url) { 'https://www.google.ru/' }

  background do
    sign_in(user)
    visit new_question_path
    page.all(:fillable_field, 'Title')[0].set('Test question')
    fill_in 'Body', with: 'Test body'
  end

  scenario 'User adds links when asks question', js: true do
    page.all(:fillable_field, 'Link name')[0].set('My gist')
    page.all(:fillable_field, 'Url')[0].set(gist_url)
    click_on 'Add link'
    page.all(:fillable_field, 'Link name')[1].set('Google')
    page.all(:fillable_field, 'Url')[1].set(google_url)
    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
    expect(page).to have_link 'Google', href: google_url
  end

  scenario 'User adds invalid link' do
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: 'wrong_url'
    click_on 'Ask'

    expect(page).to have_content 'Links url is invalid'
  end

end
