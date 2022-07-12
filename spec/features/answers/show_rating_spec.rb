require 'rails_helper'

feature 'User can see rating of an answer', %q{
  In order to see how other users evaluate an answer
  As a user
  I'd like to be able to see answer's rating
} do

  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'User tries to see rating of new answer' do
    visit question_path(question)

    within '.votes' do
      expect(page).to have_content '0'
    end
  end

  scenario 'User tries to see question with positive rating' do
    create_list(:vote, 5, voteable: answer)

    visit question_path(question)
    within '.votes' do
      expect(page).to have_content '5'
    end
  end

  scenario 'User tries to see question with negative rating' do
    create_list(:vote, 5, :downvote, voteable: answer)

    visit question_path(question)
    within '.votes' do
      expect(page).to have_content '-5'
    end
  end
end
