class AddPinbalFieldsToOrganization < ActiveRecord::Migration[5.2]
  def change
    add_column :decidim_organizations, :pinbal_user, :string
    add_column :decidim_organizations, :pinbal_pwd, :string
  end
end