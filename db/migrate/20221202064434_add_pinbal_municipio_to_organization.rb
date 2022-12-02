class AddPinbalMunicipioToOrganization < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_organizations, :pinbal_municipio, :string
  end
end
