require 'rails_helper'

feature 'User can see rating of a question', %q{
  In order to see how other users evaluate a question
  As a user
  I'd like to be able to see question's rating
} do

  given!(:question) { create(:question) }

  scenario 'User tries to see rating of new question' do
    visit questions_path

    expect(page).to have_content '0'
  end

  scenario 'User tries to see question with positive rating' do
    create_list(:vote, 5, voteable: question)

    visit questions_path
    expect(page).to have_content '5'
  end

  scenario 'User tries to see question with negative rating' do
    create_list(:vote, 5, :downvote, voteable: question)

    visit questions_path
    expect(page).to have_content '-5'
  end
end
