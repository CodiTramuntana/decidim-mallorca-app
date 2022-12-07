module ConsellMallorca
  module Admin
    class AuthorizationConfigsController < Decidim::Admin::ApplicationController
      def edit
        enforce_permission_to :update, :organization

        @organization = current_organization
        @organization.pinbal_solicitante_identificador_solicitante ||= Rails.application.secrets.pinbal_solicitante_identificador_solicitante
        @organization.pinbal_solicitante_nombre_solicitante ||= Rails.application.secrets.pinbal_solicitante_nombre_solicitante
        @organization.pinbal_solicitante_unidad_tramitadora ||= Rails.application.secrets.pinbal_solicitante_unidad_tramitadora
        @organization.pinbal_solicitante_cod_procedimiento ||= Rails.application.secrets.pinbal_solicitante_cod_procedimiento
        @organization.pinbal_solicitante_nombre_procedimiento ||= Rails.application.secrets.pinbal_solicitante_nombre_procedimiento
        @organization.pinbal_solicitante_nombre_completo_funcionario ||= Rails.application.secrets.pinbal_solicitante_nombre_completo_funcionario
        @organization.pinbal_solicitante_nif_funcionario ||= Rails.application.secrets.pinbal_solicitante_nif_funcionario
        @organization.pinbal_solicitante_id_expediente ||= Rails.application.secrets.pinbal_solicitante_id_expediente
        @organization.pinbal_solicitante_finalidad ||= Rails.application.secrets.pinbal_solicitante_finalidad
        @organization.pinbal_solicitante_consentimiento ||= Rails.application.secrets.pinbal_solicitante_consentimiento
      end

      def update
        enforce_permission_to :update, :organization

        @organization = current_organization
        @organization.update!(organization_params)
        redirect_to edit_consell_mallorca_admin_authorization_config_path, notice: t(".success")
      end

      private

      def organization_params
        params.require(:organization).permit(
          :pinbal_user,
          :pinbal_pwd,
          :pinbal_municipio,
          :pinbal_solicitante_identificador_solicitante,
          :pinbal_solicitante_nombre_solicitante,
          :pinbal_solicitante_unidad_tramitadora,
          :pinbal_solicitante_cod_procedimiento,
          :pinbal_solicitante_nombre_procedimiento,
          :pinbal_solicitante_nombre_completo_funcionario,
          :pinbal_solicitante_nif_funcionario,
          :pinbal_solicitante_id_expediente,
          :pinbal_solicitante_finalidad,
          :pinbal_solicitante_consentimiento,
          )
      end
    end
  end
end
