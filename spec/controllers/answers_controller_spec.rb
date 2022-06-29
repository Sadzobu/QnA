require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  
  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new answer to database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(Answer, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'author tries to delete answer' do
      let!(:answer) { create(:answer, question: question, author: user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end
    end

    context 'other user tries to delete answer' do
      let!(:answer) { create(:answer, question: question) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { question_id: question, id: answer }, format: :js }.to change(Answer, :count).by(0)
      end
    end

    let!(:answer) { create(:answer, question: question) }
    it 'remains on the same page' do
      delete :destroy, params: { question_id: question, id: answer }, format: :js
      expect(response).to render_template :destroy
    end
  end

  describe 'PATCH #update' do
    context 'author tries to edit answer' do
      context 'with valid attributes' do
        it 'assings the requested answer to @answer'
        it 'changes answer attributes'
        it 'renders update template'
      end

      context 'with invalid attributes' do
        it 'does not change answer attributes'
        it 'renders update template'
      end
    end

    context 'other user tries to edit answer' do
      it 'does not change answer attributes'
    end
  end

  describe 'PATCH #mark_as_best' do
    before { login(user) }

    context 'author of question marks it as best' do
      it 'saves new answer as best'
      it 'renders mark_as_best template'
    end

    context 'other user tries to mark it as best' do
      it 'does not change best answer'
    end
  end
end
