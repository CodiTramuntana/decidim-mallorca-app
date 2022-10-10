class AddPinbalFieldsToOrganization < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_organizations, :pinbal_user, :string
    add_column :decidim_organizations, :pinbal_pwd, :string
    add_column :decidim_organizations, :pinbal_solicitante_identificador_solicitante, :string
    add_column :decidim_organizations, :pinbal_solicitante_nombre_solicitante, :string
    add_column :decidim_organizations, :pinbal_solicitante_unidad_tramitadora, :string
    add_column :decidim_organizations, :pinbal_solicitante_cod_procedimiento, :string
    add_column :decidim_organizations, :pinbal_solicitante_nombre_procedimiento, :string
    add_column :decidim_organizations, :pinbal_solicitante_nombre_completo_funcionario, :string
    add_column :decidim_organizations, :pinbal_solicitante_nif_funcionario, :string
    add_column :decidim_organizations, :pinbal_solicitante_id_expediente, :string
    add_column :decidim_organizations, :pinbal_solicitante_finalidad, :string
    add_column :decidim_organizations, :pinbal_solicitante_consentimiento, :string
  end
end