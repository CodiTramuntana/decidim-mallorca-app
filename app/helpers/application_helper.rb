require "csv"

module ApplicationHelper

  def pinbal_municipio_select(f, include_blank: true)
    opts= {}
    if include_blank
      opts[:include_blank]= true
    else
      opts[:prompt]= t("decidim.authorization_handlers.consell_mallorca_authorization_handler.prompt")
    end
    f.select :pinbal_municipio, options_for_municipio, opts
  end

  def options_for_municipio
    ::CSV.parse(File.read(Rails.root.join("app/helpers/TablaMunicipios202202Mallorca.csv")), headers: false)
  end
end
