class AddMunicipalityCodeToOrganization < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_organizations, :consell_mallorca_municipality_code, :string
  end
end
