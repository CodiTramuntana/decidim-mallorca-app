module ConsellMallorca
  module Admin
    class AuthorizationConfigsController < Decidim::Admin::ApplicationController
      helper_method :municipalities_options_for_select

      def edit
        enforce_permission_to :update, :organization

        @organization = current_organization
      end

      def update
        enforce_permission_to :update, :organization

        @organization = current_organization
        @organization.update!(organization_params)
        redirect_to edit_consell_mallorca_admin_authorization_config_path, notice: t(".success")
      end

      private

      def organization_params
        params.require(:organization).permit(:pinbal_user, :pinbal_pwd)
      end

      def municipalities_options_for_select
        ConsellMallorca::Authorization::Municipalities.all
      end
    end
  end
end
