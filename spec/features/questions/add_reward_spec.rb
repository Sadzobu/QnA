require 'rails_helper'

feature 'User can add reward to question', %q{
  In order to motivate users to give best answers to my question
  As a question's author
  I'd like to be able to set a reward to question
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
    page.all(:fillable_field, 'Title')[0].set('Test question')
    fill_in 'Body', with: 'Test body'
  end

  scenario 'Authenticated user adds reward when asks question' do
    within '.reward' do
      fill_in 'Title', with: 'Reward title'
      attach_file 'File', "#{Rails.root}/spec/assets/reward.png"
    end
    click_on 'Ask'

    expect(Question.last.reward.title).to eq 'Reward title'
    expect(Question.last.reward.file.filename).to eq 'reward.png'
  end

  scenario 'Authenticated user adds reward with errors' do
    within '.reward' do
      fill_in 'Title', with: ''
      attach_file 'File', "#{Rails.root}/spec/assets/reward.png"
    end
    click_on 'Ask'

    expect(page).to have_content "Reward title can't be blank"
  end
end
