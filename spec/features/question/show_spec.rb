require 'rails_helper'

feature 'User can browse a question and answers for it', %q{
  In order to see what asnwers have been given to a question
  As a user
  I'd like to be able to browse a question and answers for it
} do

  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 2, question: question) }

  scenario 'User tries to see a question and answers for it' do
    visit questions_path
    click_on 'Show'

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each do |answer|
      expect(page).to have_content answer.body
    end

  end
end
