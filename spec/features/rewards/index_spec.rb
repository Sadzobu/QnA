require 'rails_helper'

feature 'User can browse all rewards they acquired', %q{
  In order to check all rewards i've received
  As an authenticated user
  I'd like to be able to browse my rewards
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:other_question) { create(:question, title: "MyOtherQuestion") }
  given!(:reward) { create(:reward, question: question, user: user) }
  given!(:other_reward) { create(:reward, title: 'MyOtherReward', question: other_question, user: user) }

  scenario 'Authenticated user tries to browse all their rewards', js: true do
    sign_in(user)
    click_on 'Rewards'

    expect(page).to have_content reward.question.title
    expect(page).to have_content reward.title

    expect(page).to have_content other_reward.question.title
    expect(page).to have_content other_reward.title
    expect(page).to have_css('img').twice
  end

  scenario 'Unauthenticated user tries to browse rewards' do
    expect(page).to_not have_link 'Rewards'
  end
end
