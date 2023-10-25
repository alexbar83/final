require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of :body }

  describe 'send answer notifications' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'sends notification to question author after create' do
      expect(NewAnswerMailer).to receive(:new_answer).with(user, answer).and_call_original
      create(:answer, user: user, question: question)
    end
  end

  it { should accept_nested_attributes_for :links }

  it_behaves_like 'votable'

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
