require 'rails_helper'

feature 'User can see rating of a question', %q{
  In order to see how other users evaluate a question
  As a user
  I'd like to be able to see question's rating
} do

  scenario 'User tries to see rating of new question' 
  scenario 'User tries to see question with positive rating'
  scenario 'User tries to see question with negative rating'
end
