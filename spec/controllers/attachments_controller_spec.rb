require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'author of resource tries to delete attachment' do
      let!(:question) { create(:question, :with_attachment, author: user) }

      it 'deletes attachment' do
        expect { delete :destroy, params: { id: question.files[0] }, format: :js }.to change(question.files, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, params: { id: question.files[0] }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context "user tries to delete other user's resource" do
      let(:other_question) { create(:question, :with_attachment) }

      it 'does not delete attachment' do
        expect { delete :destroy, params: { id: other_question.files[0] }, format: :js }.to change(other_question.files, :count).by(0)
      end
    end
  end
end
