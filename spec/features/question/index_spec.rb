require 'rails_helper'

feature 'User can see a list of all questions', %q{
  In order to see what questions have been asked
  As a user
  I'd like to be able to see a list of all questions
} do

  given!(:questions) { create_list(:question, 2) }

  scenario 'User tries to see a list of all questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end
end
