# frozen_string_literal: true

# Connects to the "Servicio de Verificación de Datos de Residencia en un Ámbito Territorial" service
# to check for residence registration
module ResidenceVerification
  class Client

    BIRTHDATE_REGEXP= /<DatosNacimiento><Fecha>(\d{8})<\/Fecha>/

    attr_reader :birthday, :client, :codigo_estado_respuesta

    # The Organization with the Pinbal user and password
    def initialize(organization)
      @organization = organization
      @user = @organization.pinbal_user
      @password = @organization.pinbal_pwd
    end

    def send_request(document_type, document_number, surname)
      tituar= ResidenceVerification::Rq::Titular.new(document_type.to_sym, document_number, surname)
      document_body= ResidenceVerification::Rq::DocumentBody.new(@organization, tituar).to_h

      response = invoke_endpoint(document_body.to_json)
      json_response = JSON.parse(response.body)
      @codigo_estado_respuesta= json_response.dig("atributos", "estado", "codigoEstado")
      json_response["transmisiones"]&.first&.fetch("datosEspecificos") =~ BIRTHDATE_REGEXP
      @birthday= $1
      response.body
    rescue Exception => e
      Rails.logger.error "ERROR: ResidenceVerification request failed: #{e.message}::#{e.backtrace}"
      false
    end

    #------------------------------------------------------
    private
    #------------------------------------------------------

    def invoke_endpoint(json_document)
      conn = Faraday.new do |conn|
        conn.request :authorization, "Basic", basic_auth_credentials
        conn.request :json
        conn.options.timeout = 300 # seconds
      end
      rs = conn.post(Rails.application.secrets.pinbal_endpoint_url, json_document) do |conn|
        conn.headers = {
          "Accept" => "application/json", "Content-Type" => "application/json"
        }
      end
    end

    def basic_auth_credentials
      @basic_auth_credentials= Base64.encode64("#{@user}:#{@password}")
    end
  end
end