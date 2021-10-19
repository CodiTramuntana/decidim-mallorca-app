# frozen_string_literal: true

# Connects to the "Servicio de Verificación de Datos de Residencia en un Ámbito Territorial" service
# to check for residence registration
module ResidenceVerification
  class Client

    attr_reader :codigo_estado_respuesta

    def initialize
      @client = Savon.client(wsdl: Rails.root.join('lib/consell_mallorca/authorization/ws/INE.VerificacionAmbitoResidencia.wsdl'), endpoint: endpoint_url) do
        path= Rails.root.join(Rails.env.production? ? "config" : "spec/support")
        akami_wsse_certs= Akami::WSSE::Certs.new(cert_file: path.join("certs/cert.pem"), private_key_file: path.join("certs/key.pem"))
        wsse_signature Akami::WSSE::Signature.new(akami_wsse_certs)
      end
    end

    def send_request(document_type, document_number, municipality_code)
      tituar= ResidenceVerification::Rq::Titular.new(document_type.to_sym, document_number, municipality_code)
      soap_body= ResidenceVerification::Rq::SoapBody.new(tituar).to_h

      response = @client.call(:peticion_sincrona, message: soap_body)
      @codigo_estado_respuesta= response.body.dig(:respuesta, :transmisiones, :transmision_datos, :datos_especificos, :retorno, :estado, :codigo_estado)
      response.body
    end

    #------------------------------------------------------
    private
    #------------------------------------------------------

    def endpoint_url
      if Rails.env.production?
        "https://intermediacion.redsara.es/servicios/SVD/INE.VerificacionAmbitoResidencia"
      else
        "https://intermediacionpp.redsara.es/servicios/SVD/INE.VerificacionAmbitoResidencia"
      end
    end
  end
end
