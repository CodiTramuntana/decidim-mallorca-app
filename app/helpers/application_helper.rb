require "csv"

module ApplicationHelper

  def pinball_municipio_select(f)
    f.select :pinbal_municipio, options_for_municipio, { include_blank: true }
  end

  def options_for_municipio
    ::CSV.parse(File.read(Rails.root.join("app/helpers/TablaMunicipios202202Mallorca.csv")), headers: false)
  end
end
