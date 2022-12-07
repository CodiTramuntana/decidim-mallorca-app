# frozen_string_literal: true

# An AuthorizationHandler that checks residence registration against the
# "Servicio de Verificación de Datos de Residencia en un Ámbito Territorial" service
class ConsellMallorcaAuthorizationHandler < Decidim::AuthorizationHandler

  attribute :document_type, Symbol
  attribute :document_number, String
  attribute :surname, String
  attribute :birthdate, String
  attribute :pinbal_municipio, String

  validates :document_type, inclusion: { in: [:dni, :nie, :passport] }, presence: true
  validates :document_number, presence: true
  validates :pinbal_municipio, presence: true#, if: -> { ask_municipality_to_citizen? }
  validate :censed

  # Helper method to be used in the form.
  # Returns the document types as options for select tags.
  def census_document_types
    [:dni, :nie, :passport].map do |type|
      [
        I18n.t(type, scope: %w(decidim authorization_handlers
                               consell_mallorca_authorization_handler
                               document_types)),
        type
      ]
    end
  end

  def unique_id
    Digest::SHA256.hexdigest(
      "#{document_type}-#{document_number}-#{municipality_code}-#{Rails.application.secrets.secret_key_base}"
    )
  end

  def metadata
    {birthdate: birthdate, district: pinbal_municipio}
  end

  def ask_municipality_to_citizen?
    organization.pinbal_municipio.blank?
  end

  # -------------------------------------------------------------------------------
  private
  # -------------------------------------------------------------------------------

  def censed
    client = ResidenceVerification::Client.new(organization)
    begin
      rs_body= client.send_request(document_type, document_number, surname, pinbal_municipio)
      if client.codigo_estado_respuesta != "0003"
        Rails.logger.warn { "User is not censed. CodigoRespuesta was #{client.codigo_estado_respuesta}. RS: #{rs_body}" }
        errors.add(:base, I18n.t("decidim.consell_mallorca_authorization.errors.messages.not_censed"))
      else
        tmp= client.birthday
        @birthdate= "#{tmp[0,4]}/#{tmp[4,2]}/#{tmp[6,2]}"
      end
    rescue Exception => e
      Rails.logger.error("Error: #{e.message}. Backtrace: #{e.backtrace.join("\n")}")
      errors.add(:base, I18n.t("decidim.consell_mallorca_authorization.errors.messages.rq_failed"))
    end
  end

  def municipality_code
    @municipality_code||= organization.pinbal_user
  end

  def organization
    current_organization || user.try(:organization)
  end
end
