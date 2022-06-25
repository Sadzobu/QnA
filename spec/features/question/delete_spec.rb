require 'rails_helper'

feature 'User can delete their question', %q{
  In order to remove their question from application
  As an authenticated user
  I'd like to be able to delete a question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  background { sign_in(user) }

  scenario 'Authenticated user tries to delete their question' do

    visit questions_path

    click_on 'Delete'

    expect(page).to_not have_content question.title
  end

end
