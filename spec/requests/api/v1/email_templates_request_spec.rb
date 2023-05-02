require 'rails_helper'

RSpec.describe "Api::V1::EmailTemplatesController", type: :request do
  let!(:event) { create :event }
  let!(:user) { create :user }

  describe "GET /api/v1/events/:event_id/templates" do
    let!(:templates_list) { create_list :email_template, 3, event: event, user: user}

    it "should return a json list of templates" do
      get "/api/v1/events/#{event.id}/templates"
      expect(response).to be_successful
      expect(response.content_type).to eq("application/json; charset=utf-8")
      
      templates = JSON.parse response.body
      expect(templates.length).to be == 3
      expect(templates[0]).to include("name", "subject", "body", "attachments")
    end
  end

  describe 'POST /api/v1/events/:event_id/templates' do
    it 'should create a new template' do
      p = attributes_for(:email_template, user_id: user.id, attachments: [fixture_file_upload('img/jpg/img-64x64.jpg', 'image/jpeg')] )
      post "/api/v1/events/#{event.id}/templates", params: p
      expect(response).to be_successful
    end
  end

  describe 'PATCH /api/v1/events/:event_id/templates/:id' do
    context 'there is an email template under an event' do
      let!(:template) { create :email_template, event: event, user: user}
      it 'should update the template' do
        p = {name: 'My new name'}
        patch "/api/v1/events/#{event.id}/templates/#{template.id}", params: p
        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE /api/v1/events/:event_id/templates/:id' do
    context 'there is an email template under an event' do
      let!(:template) { create :email_template, event: event, user: user }
      it 'should delete an existing record' do
        expect {
          delete "/api/v1/events/#{event.id}/templates/#{template.id}"
        }.to change { EmailTemplate.count }.by(-1)
      end
    end
  end
end
