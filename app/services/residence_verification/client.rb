# frozen_string_literal: true

# Connects to the "Servicio de Verificación de Datos de Residencia en un Ámbito Territorial" service
# to check for residence registration
module ResidenceVerification
  class Client

    PINBAL_ENDPOINT_URL = "https://proves.caib.es/pinbalapi/interna/recobriment/peticionSincrona"

    attr_reader :codigo_estado_respuesta, :client

    # The Pinbal user and password
    def initialize(user, password)
      @user = user
      @password = password
    end

    def send_request(document_type, document_number, surname)
      tituar= ResidenceVerification::Rq::Titular.new(document_type.to_sym, document_number, surname)
      document_body= ResidenceVerification::Rq::DocumentBody.new(tituar).to_h

      response = invoke_endpoint(document_body.to_json)
      json_response = JSON.parse(response.body)
      @codigo_estado_respuesta= json_response.dig("atributos", "estado", "codigoEstado")
      response.body
    rescue Exception => e
      Rails.logger.error "ERROR: ResidenceVerification request failed: #{e.message}::#{e.backtrace}"
      false
    end

    #------------------------------------------------------
    private
    #------------------------------------------------------

    def invoke_endpoint(json_document)
      conn = Faraday.new do |faraday|
        faraday.request :authorization, "Basic", basic_auth_credentials
        faraday.request :json
      end
      rs = conn.post(PINBAL_ENDPOINT_URL, json_document) do |conn|
        conn.headers = {
          "Accept" => "application/json", "Content-Type" => "application/json"
        }
      end
    end

    def basic_auth_credentials
      @basic_auth_credentials= Base64.encode64("#{@user}:#{@password}")
    end

    def json_document
      doc= <<EODOC
      {
        "atributos": {"numElementos":"1","codigoCertificado":"SVDDGPCIWS02"},
        "solicitudes":[{
          "datosGenericos": {
            "emisor": {"nifEmisor":"S2833002E", "nombreEmisor":"MINISTERIO DE HACIENDA Y AP"},
            "solicitante": {
              "identificadorSolicitante":"S0711001H",
              "nombreSolicitante":"CONSELL INSULAR DE MALLORCA",
              "unidadTramitadora":"DIRECCIO INSULAR DE PARTICIPACIO",
              "procedimiento": {"codProcedimiento":"CODSVDR_GBA_20121107","nombreProcedimiento": "PRUEBAS DE INTEGRACION PARA GOBIERNO DE BALEARES"},
              "funcionario": {"nombreCompletoFuncionario":"Funcionari Consell","nifFuncionario":"00000000T"},
              "idExpediente": "EXP/18122012",
              "finalidad":"Test peticionSincrona",
              "consentimiento":"Si"
            },
            "titular":
                {"tipoDocumentacion":"DNI",
                "documentacion":"10000322Z",
                "nombre": "MANUELA",
                "apellido1": "BLANCO",
                "apellido2": "VIDAL"}
            },
        "datosEspecificos":
          "<?xml version=\"1.0\" encoding=\"UTF-8\"?><ns1:DatosEspecificos xmlns:ns1=\"http://intermediacion.redsara.es/scsp/esquemas/datosespecificos\"></ns1:DatosEspecificos>"}
        ]
      }
EODOC
    end
  end
end