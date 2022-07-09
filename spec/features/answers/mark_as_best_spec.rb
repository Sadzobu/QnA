require 'rails_helper'

feature 'User can mark answer as best on their question', %q{
  In order to show other users the best answer
  As an authenticated user and author of the question
  I'd like to be able to mark answer as best
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:other_question) { create(:question) }
  given!(:answers) { create_list(:answer, 3, question: question) }

  describe 'Authenticated user' do
    background { sign_in(user) }

    scenario 'marks answer best on their question', js: true do
      visit question_path(question)
      new_best_answer = answers[2]

      within('.answers') do
        within("#answer_#{new_best_answer.id}") do
          click_on 'Best'
        end

        expect(current_path).to eq question_path(question)
        expect(page).to have_css '.best_answer'
      end
    end

    scenario 'tries to mark answer best on other users question' do
      visit question_path(other_question)

      expect(page).to_not have_link('Best')
    end
  end

  scenario 'Unauthenticated user tries to mark answer best' do
    visit question_path(question)

    expect(page).to_not have_link('Best')
  end

  scenario 'There could be only one best answer', js: true do
    sign_in(user)
    visit question_path(question)
    old_best_answer = answers[2]
    new_best_answer = answers[0]

    within('.answers') do
      within("#answer_#{old_best_answer.id}") do
        click_on 'Best'
      end
    
      within("#answer_#{new_best_answer.id}") do
        click_on 'Best'
      end

      expect(page).to_not have_css('.best_answer').twice
    end
  end

  scenario 'Best answer should be first in answers', js: true do
    sign_in(user)
    visit question_path(question)
    new_best_answer = answers[2]

    within('.answers') do
      within("#answer_#{new_best_answer.id}") do
        click_on 'Best'
      end
    end

    expect(find('.answers', match: :first)).to have_css '.best_answer'
  end

  given(:best_answer_user) { create(:user) }
  given(:question) { create(:question, :with_reward, author: user) }
  given!(:answer) { create(:answer, question: question, author: best_answer_user) }
  scenario 'Best answer author receives reward for that question', js: true do
    sign_in(user)
    visit question_path(question)

    within("#answer_#{answer.id}") do
      click_on 'Best'
    end

    wait_for_ajax
    expect(best_answer_user.rewards.last).to eq question.reward
  end
end
