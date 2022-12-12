require "csv"

module ApplicationHelper

  def pinbal_municipio_select(f, include_blank: true)
    opts= {}
    opts[:prompt]= t("decidim.authorization_handlers.consell_mallorca_authorization_handler.prompt") unless include_blank
    f.select :pinbal_municipio, options_for_municipio, opts
  end

  def options_for_municipio
    ::CSV.parse(File.read(Rails.root.join("app/helpers/TablaMunicipios202202Mallorca.csv")), headers: false)
  end
end
