# frozen_string_literal: true

require "rails_helper"

describe ConsellMallorcaAuthorizationHandler do
  let(:organization) { FactoryBot.create(:organization, pinbal_user: "test_municipality_user", pinbal_pwd: "son_moix") }
  let(:user) { FactoryBot.create(:user, organization: organization, nickname: "nickname") }
  let(:dni) { "00000000T" }
  let(:surname) { "BLANCO" }
  let(:handler) do
    ConsellMallorcaAuthorizationHandler.new(user: user, document_type: :dni, document_number: dni, surname: surname)
                              .with_context(current_organization: organization)
  end

  it "validates" do
    stub_request(:post, Rails.application.secrets.pinbal_endpoint_url).
      to_return(status: 200, body: json_response, headers: {})

    expect(handler.valid?).to be true
    expect(handler.birthdate).to eq("2002/09/05")
  end

  it "#unique_id" do
    encoded= Digest::SHA256.hexdigest(
      "dni-#{dni}-test_municipality_user-#{Rails.application.secrets.secret_key_base}"
    )
    expect(handler.unique_id).to eq(encoded)
  end

  it "#metadata" do
    handler.birthdate= "2000/01/02"
    expect(handler.metadata).to eq({birthdate: "2000/01/02"})
  end

  def json_response
    <<EOJSON
{
  "atributos":{
    "idPeticion":"PINBAL00000000000000266096",
    "numElementos":"1",
    "timeStamp":"2022-08-09T16:41:04.402+02:00",
    "codigoCertificado":"SVDDGPCIWS02",
    "estado":{
      "codigoEstado":"0003",
      "codigoEstadoSecundario":null,
      "literalError":"Tramitada",
      "literalErrorSec":null,
    "tiempoEstimadoRespuesta":0
    }
  },
  "transmisiones":[{
    "id":null,
    "datosGenericos": {
      "emisor": {"nifEmisor":"S2816015H","nombreEmisor":"Dirección General de la Policía"},
      "solicitante":{
        "procedimiento":{"codProcedimiento":"CODSVDR_GBA_20121107","nombreProcedimiento":"PRUEBAS DE INTEGRACION PARA GOBIERNO DE BALEARES"},
        "funcionario":{"nombreCompletoFuncionario":"Funcionari Consell","nifFuncionario":"00000000T","seudonimo":null},
        "unidadTramitadora":"DIRECCIO INSULAR DE PARTICIPACIO",
        "codigoUnidadTramitadora":null,
        "identificadorSolicitante":"S0711001H",
        "nombreSolicitante":"Govern de les Illes Balears",
        "idExpediente":"EXP/18122012",
        "finalidad":"CODSVDR_GBA_20121107#::#EXP/18122012#::#Test peticionSincrona",
        "consentimiento":"Si"},
      "titular":{
        "tipoDocumentacion":"DNI",
        "documentacion":"10000322Z",
        "nombreCompleto":"MANUELA BLANCO VIDAL",
        "nombre":"MANUELA",
        "apellido1":"BLANCO",
        "apellido2":"VIDAL"
      },
      "transmision":{
        "codigoCertificado":"SVDDGPCIWS02",
        "idSolicitud":"PINBAL00000000000000266096",
        "idTransmision":"PRE0002408428793",
        "fechaGeneracion":"2022-08-09T16:41:04.396+02:00"
      }
    },
    "datosEspecificos":"<DatosEspecificos><Retorno><Estado><CodigoEstado>00</CodigoEstado><LiteralError>INFORMACION CORRECTA</LiteralError></Estado><DatosTitular><Nombre>MANUELA</Nombre><Apellido1>BLANCO</Apellido1><Apellido2>VIDAL</Apellido2><Nacionalidad>ESPAÿA-ESP</Nacionalidad><Sexo>F</Sexo><DatosNacimiento><Fecha>20020905</Fecha><Localidad>VIGO</Localidad><Provincia>PONTEVEDRA</Provincia></DatosNacimiento><NombreMadre>JULIA</NombreMadre><FechaCaducidad>20070701</FechaCaducidad></DatosTitular></Retorno></DatosEspecificos>"}
  ]
}
EOJSON
  end

end
