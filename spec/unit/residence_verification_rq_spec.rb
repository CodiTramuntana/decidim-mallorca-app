# frozen_string_literal: true

require "rails_helper"

describe "ResidenceVerification request" do
  let!(:organization) { create(:organization,
      pinbal_solicitante_identificador_solicitante: Rails.application.secrets.pinbal_solicitante_identificador_solicitante,
      pinbal_solicitante_nombre_solicitante: Rails.application.secrets.pinbal_solicitante_nombre_solicitante,
      pinbal_solicitante_unidad_tramitadora: Rails.application.secrets.pinbal_solicitante_unidad_tramitadora,
      pinbal_solicitante_cod_procedimiento: Rails.application.secrets.pinbal_solicitante_cod_procedimiento,
      pinbal_solicitante_nombre_procedimiento: Rails.application.secrets.pinbal_solicitante_nombre_procedimiento,
      pinbal_solicitante_finalidad: Rails.application.secrets.pinbal_solicitante_finalidad,
      pinbal_solicitante_consentimiento: Rails.application.secrets.pinbal_solicitante_consentimiento,
    )}

  shared_examples "a document body" do
    it "should produce the request msg" do
      rq= ResidenceVerification::Rq::DocumentBody.new(organization, tituar).to_h
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

      expected_datos_especificos= <<-EOEDE
  <?xml version=\"1.0\" encoding=\"UTF-8\"?><ns1:DatosEspecificos xmlns:ns1=\"http://intermediacion.redsara.es/scsp/esquemas/datosespecificos\"><ns1:Solicitud><ns1:Espanol>s</ns1:Espanol><ns1:Residencia><ns1:Provincia>07</ns1:Provincia><ns1:Municipio>001</ns1:Municipio></ns1:Residencia></ns1:Solicitud></ns1:DatosEspecificos>
  EOEDE
      expect(solicitud[:datosEspecificos]).to eq(expected_datos_especificos.strip)
      puts rq.to_json
    end
  end

  context "when the organization has the municipality" do
    let(:tituar) { ResidenceVerification::Rq::Titular.new(:dni, "10000322Z", "BLANCO", nil) }
    before do
      organization.update(pinbal_municipio: "001")
    end

    it_should_behave_like "a document body"
  end

  context "when the citizen introduces the municipality" do
    let(:tituar) { ResidenceVerification::Rq::Titular.new(:dni, "10000322Z", "BLANCO", "001") }

    it_should_behave_like "a document body"
  end
end
