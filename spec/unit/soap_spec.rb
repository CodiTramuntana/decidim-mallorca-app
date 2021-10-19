# frozen_string_literal: true

require "rails_helper"
require "savon"

describe "Soap client" do
  it "should have the correct wsdl" do
    client = ResidenceVerification::Client.new.client

    expect(client.operations).to eq([:peticion_sincrona])
  end

  it "should produce the request msg" do
    tituar= ResidenceVerification::Rq::Titular.new(:nif, "00000000T", "0027")
    rq= ResidenceVerification::Rq::SoapBody.new(tituar).to_h
    expect(rq[:Peticion][:Atributos][:IdPeticion]).to start_with("SVDRWS01-")
    expect(rq[:Peticion][:Atributos][:NumElementos]).to eq(1)
    expect(rq[:Peticion][:Atributos][:TimeStamp]).to be_present
    expect(rq[:Peticion][:Atributos][:CodigoCertificado]).to eq("SVDRWS01")

    solicitud= rq[:Peticion][:Solicitudes].first[:SolicitudTransmision]
    expect(solicitud[:DatosGenericos][:Emisor][:NifEmisor]).to eq("S2833002E")
    expect(solicitud[:DatosGenericos][:Emisor][:NombreEmisor]).to eq("Ministerio de Hacienda y Administraciones Públicas")
    expect(solicitud[:DatosGenericos][:Titular][:TipoDocumentacion]).to eq("NIF")
    expect(solicitud[:DatosGenericos][:Titular][:Documentacion]).to eq("00000000T")
    expect(solicitud[:DatosGenericos][:Transmision][:CodigoCertificado]).to eq("SVDRWS01")
    expect(solicitud[:DatosGenericos][:Transmision][:IdSolicitud]).to start_with("SVDRWS01-")

    expect(solicitud[:DatosEspecificos][:Espanol]).to eq("s")
    expect(solicitud[:DatosEspecificos][:Residencia][:Provincia]).to eq("07")
    expect(solicitud[:DatosEspecificos][:Residencia][:Municipio]).to eq("0027")
  end
end
