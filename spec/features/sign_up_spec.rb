require 'rails_helper'

feature 'User can sign up', %q{
  In order to gain access to application's full functionality
  As a user
  I'd like to be able to sign up
} do

  background {  visit new_user_registration_path }

  scenario 'User tries to sign up' do
    fill_in 'Email', with: 'test@ya.ru'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'User tries to sign up with invalid information' do
    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
  end


end
