require 'rails_helper'

feature 'User can delete their answer', %q{
  In order to remove their answer from question in application
  As an authenticated user and answer's author
  I'd like to be able to delete an answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: user) }

  background { sign_in(user) }

  scenario 'Authenticated user tries to delete their answer' do
    visit question_path(question)

    click_on 'Delete'

    expect(page).to_not have_content answer.body
  end
end
