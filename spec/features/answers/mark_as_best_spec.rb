require 'rails_helper'

feature 'User can mark answer as best on their question', %q{
  In order to show other users the best answer
  As an authenticated user and author of the question
  I'd like to be able to mark answer as best
} do
  describe 'Authenticated user' do
      scenario 'marks answer best on their question'

      scenario 'tries to mark answer best on other users question'
  end

  scenario 'Unauthenticated user tries to mark answer best'

  scenario 'Best answer should be first in answers block'

end
