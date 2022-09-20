# frozen_string_literal: true

require "rails_helper"

describe "ResidenceVerification request" do
  it "should produce the request msg" do
    tituar= ResidenceVerification::Rq::Titular.new(:dni, "10000322Z", "BLANCO")
    rq= ResidenceVerification::Rq::DocumentBody.new(tituar).to_h
    expect(rq[:atributos][:idPeticion]).to start_with("SVDRWS01-")
    expect(rq[:atributos][:numElementos]).to eq("1")
    expect(rq[:atributos][:timeStamp]).to be_present
    expect(rq[:atributos][:codigoCertificado]).to eq("SVDDGPCIWS02")

    solicitud= rq[:solicitudes].first
    expect(solicitud[:datosGenericos][:emisor][:nifEmisor]).to eq("S2833002E")
    expect(solicitud[:datosGenericos][:emisor][:nombreEmisor]).to eq("Ministerio de Hacienda y Administraciones Públicas")
    expect(solicitud[:datosGenericos][:solicitante][:identificadorSolicitante]).to eq("S0711001H")
    expect(solicitud[:datosGenericos][:solicitante][:nombreSolicitante]).to eq("CONSELL INSULAR DE MALLORCA")
    expect(solicitud[:datosGenericos][:solicitante][:unidadTramitadora]).to eq("DIRECCIO INSULAR DE PARTICIPACIO")
    expect(solicitud[:datosGenericos][:solicitante][:procedimiento][:codProcedimiento]).to eq("CODSVDR_GBA_20121107")
    expect(solicitud[:datosGenericos][:solicitante][:procedimiento][:nombreProcedimiento]).to eq("PRUEBAS DE INTEGRACION PARA GOBIERNO DE BALEARES")
    expect(solicitud[:datosGenericos][:solicitante][:finalidad]).to eq("Poder participar en la plataforma de participación del Consell de Mallorca")
    expect(solicitud[:datosGenericos][:solicitante][:consentimiento]).to eq("Si")
    expect(solicitud[:datosGenericos][:titular][:tipoDocumentacion]).to eq("DNI")
    expect(solicitud[:datosGenericos][:titular][:documentacion]).to eq("10000322Z")
    expect(solicitud[:datosGenericos][:titular][:apellido1]).to eq("BLANCO")
    # expect(solicitud[:datosGenericos][:transmision][:codigoCertificado]).to eq("SVDDGPCIWS02")
    # expect(solicitud[:datosGenericos][:transmision][:idSolicitud]).to start_with("SVDRWS01-")

    expect(solicitud[:datosEspecificos]).to eq("<?xml version=\"1.0\" encoding=\"UTF-8\"?><ns1:DatosEspecificos xmlns:ns1=\"http://intermediacion.redsara.es/scsp/esquemas/datosespecificos\"></ns1:DatosEspecificos>")
    # expect(solicitud[:datosEspecificos][:espanol]).to eq("s")
    # expect(solicitud[:datosEspecificos][:residencia][:provincia]).to eq("07")
    # expect(solicitud[:datosEspecificos][:residencia][:municipio]).to eq("0027")
    puts rq.to_json
  end
end
