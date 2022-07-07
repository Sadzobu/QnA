require 'rails_helper'

feature 'Answer links to gist.github.com additionally show gist content', %q{
  In order to quickly see content of gist
  As a user
  I would like to be able to see content of gist link
} do

  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }
  given(:gist_url) { 'https://gist.github.com/Sadzobu/a4f6dc257c2b0f00b8204f2c738a0d31' }
  given!(:link) { create(:link, url: gist_url, linkable: answer) }

  scenario 'Content of link to gist is properly displayed' do
    visit question_path(question)

    within "#answer_#{answer.id}" do
      within '.links' do
        expect(page).to have_content 'Hello, world'
      end
    end
  end
end
