# frozen_string_literal: true

# An AuthorizationHandler that checks residence registration against the
# "Servicio de Verificación de Datos de Residencia en un Ámbito Territorial" service
class ConsellMallorcaAuthorizationHandler < Decidim::AuthorizationHandler

  attribute :document_type, Symbol
  attribute :document_number, String
  attribute :surname, String

  validates :document_type, inclusion: { in: [:nif, :nie, :passport] }, presence: true
  validates :document_number, presence: true
  validate :censed

  # Helper method to be used in the form.
  # Returns the document types as options for select tags.
  # As NIF and DNI are the same number, we only offer the NIF possibility.
  def census_document_types
    [:nif, :nie, :passport].map do |type|
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

  # -------------------------------------------------------------------------------
  private
  # -------------------------------------------------------------------------------

  def censed
    client = ResidenceVerification::Client.new(organization)
    begin
      rs_body= client.send_request(document_type, document_number, surname)
      if client.codigo_estado_respuesta != "0003"
        Rails.logger.warn { "User is not censed. CodigoRespuesta was #{client.codigo_estado_respuesta}. RS: #{rs_body}" }
        errors.add(:base, I18n.t("decidim.consell_mallorca_authorization.errors.messages.not_censed"))
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
