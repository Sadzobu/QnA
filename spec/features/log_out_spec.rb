require 'rails_helper'

feature 'User can log out', %q{
  In order to finish working with application
  As an authenticated user
  I'd like to be able to log out
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user tries to log out' do
    sign_in(user)
    visit questions_path
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
