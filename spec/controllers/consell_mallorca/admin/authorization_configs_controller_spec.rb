# frozen_string_literal: true

require "rails_helper"

# require Rails.root.join "app/controllers", "consell_mallorca/admin/authorization_configs_controller"

RSpec.describe ConsellMallorca::Admin::AuthorizationConfigsController,
               type: :controller do
  include Warden::Test::Helpers

  let(:organization) do
    FactoryBot.create :organization,
                      available_authorizations: ["consell_mallorca_census"]
  end

  let(:user) do
    FactoryBot.create :user, :confirmed, :admin_terms_accepted, organization: organization, admin: true#, nickname: "nickname"
  end

  before do
    controller.request.env["decidim.current_organization"] = organization
  end

  describe "GET #edit" do
    it "returns http success" do
      sign_in user
      get :edit
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH #update" do
    it "updates the current organization" do
      sign_in user
      patch :update, params: {
        organization: {
          consell_mallorca_municipality_code: "0630",
        }
      }
      expect(response).to have_http_status(:redirect)
      expect(organization.consell_mallorca_municipality_code).to eq("0630")
    end
  end
end
