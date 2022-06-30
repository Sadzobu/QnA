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
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end
    end

    context 'other user tries to delete answer' do
      let!(:answer) { create(:answer, question: question) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(0)
      end
    end

    let!(:answer) { create(:answer, question: question) }
    it 'remains on the same page' do
      delete :destroy, params: { id: answer }, format: :js
      expect(response).to render_template :destroy
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    let!(:answer) { create(:answer, author: user) }
    context 'author tries to edit answer' do
      context 'with valid attributes' do
        it 'assings the requested answer to @answer' do
          patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
          expect(assigns(:answer)).to eq answer
        end

        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'Test body' }, format: :js }
          answer.reload
          expect(answer.body).to eq 'Test body'
        end

        it 'renders update template' do
          patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not change answer attributes' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }
          answer.reload

          expect(answer.body).to eq 'MyAnswer'
        end

        it 'renders update template' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }
          expect(response).to render_template :update
        end
      end
    end

    let!(:answer) { create(:answer) }
    context "user tries to edit other user's answer" do
      it 'does not change answer attributes' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
        answer.reload

        expect(answer.body).to eq 'MyAnswer'
      end
    end
  end

  describe 'PATCH #mark_as_best' do
    before { login(user) }

    let!(:question) { create(:question, author: user) }
    let!(:answer) { create(:answer, question: question) }

    context 'author of question marks it as best' do
      it 'assings the answer.question to @question' do
        patch :mark_as_best, params: { id: answer }, format: :js
        expect(assigns(:question)).to eq answer.question
      end

      it 'saves new answer as best' do
        patch :mark_as_best, params: { id: answer }, format: :js
        answer.reload

        expect(answer.best?).to be true
      end

      it 'renders mark_as_best template' do
        patch :mark_as_best, params: { id: answer }, format: :js
        expect(response).to render_template :mark_as_best
      end
    end

    context 'other user tries to mark it as best' do
      let!(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question) }
      
      it 'does not change best answer' do
        patch :mark_as_best, params: { id: answer }, format: :js
        answer.reload

        expect(answer.best?).to be false
      end
    end
  end
end
