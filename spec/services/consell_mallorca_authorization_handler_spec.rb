# frozen_string_literal: true

require "rails_helper"

describe ConsellMallorcaAuthorizationHandler do
  let(:organization) { FactoryBot.create(:organization, consell_mallorca_municipality_code: "0001") }
  let(:user) { FactoryBot.create(:user, organization: organization, nickname: "nickname") }
  let(:nif) { "00000000T" }
  let(:handler) do
    ConsellMallorcaAuthorizationHandler.new(user: user, document_type: :nif, document_number: nif, municipality_code: organization.consell_mallorca_municipality_code)
                              .with_context(current_organization: organization)
  end

  it "validates" do
    stub_request(:post, Rails.application.secrets.ine_endpoint_url).
      to_return(status: 200, body: soap_response, headers: {})

    expect(handler.valid?).to be true
  end

  it "do not generate metadata" do
    expect(handler.metadata).to be_empty
  end

  it "#unique_id" do
    encoded= Digest::SHA256.hexdigest(
      "nif-#{nif}-0001-#{Rails.application.secrets.secret_key_base}"
    )
    expect(handler.unique_id).to eq(encoded)
  end

  def soap_response
    <<EOSOAP


<?xml version="1.0" encoding="UTF-8"?>
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns="http://www.map.es/scsp/esquemas/V2/respuesta">
  <soapenv:Header>
    <ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
      <ds:SignedInfo>
        <ds:CanonicalizationMethod Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#" />
        <ds:SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" />
        <ds:Reference URI="#Body">
          <ds:Transforms>
            <ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#" />
          </ds:Transforms>
          <ds:DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" />
          <ds:DigestValue>PYJCeeqz5FFPxaI4q9/C5S1Xnik=</ds:DigestValue>
        </ds:Reference>
      </ds:SignedInfo>
      <ds:SignatureValue>m/9r8uruL/UsWYP9WqtsRfEBzD5dAtEG1iGTdjC3By1Xed2hr4pII2CjBHiWvYj/zNM0hl7ptUs2
DEKywf9+knC4YneyQC/iQEPo6R4q2urtRiyuHaVs/COI4FuT9gxS5hXZs10nkQJRvy0r0l4RRGsq
J3Tv9Rm2Iq7PDx9CORc=</ds:SignatureValue>
      <ds:KeyInfo>
        <ds:X509Data>
          <ds:X509Certificate>MIID5TCCA06gAwIBAgIEPLycwjANBgkqhkiG9w0BAQUFADA2MQswCQYDVQQGEwJFUzENMAsGA1UE
ChMERk5NVDEYMBYGA1UECxMPRk5NVCBDbGFzZSAyIENBMB4XDTEwMDQyNjExNTYyOFoXDTE0MDQy
NjExNTYyOFowgYMxCzAJBgNVBAYTAkVTMQ0wCwYDVQQKEwRGTk1UMRgwFgYDVQQLEw9GTk1UIENs
YXNlIDIgQ0ExETAPBgNVBAsTCFB1YmxpY29zMRIwEAYDVQQLEwk1MDAwNzAwMTUxJDAiBgNVBAMT
G2ludGVybWVkaWFjaW9ucHAucmVkc2FyYS5lczCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEA
4DpH4O05vkTj4IWyo/ErY4poauqaI/uU/pJap3an0waePLdxm4p4VgI/zc/nOLGJoF7ZI1zMf01I
CwcGTgklWB/UTGyLNZtgv8vi3wAfSEasWRoLuSzJ+gnIJ2GBuIkyr88HdD52XVNl2IMPNlf9Vg3l
crzu6oAok4dRLZYmQJcCAwEAAaOCAbAwggGsMIGfBgNVHREEgZcwgZSkdTBzMRgwFgYJKwYBBAGs
ZgEPEwlTMjgxMTAwMUMxKzApBgkrBgEEAaxmAQ4THE1JTklTVEVSSU8gREUgTEEgUFJFU0lERU5D
SUExKjAoBgkrBgEEAaxmAQgTG2ludGVybWVkaWFjaW9ucHAucmVkc2FyYS5lc4IbaW50ZXJtZWRp
YWNpb25wcC5yZWRzYXJhLmVzMAkGA1UdEwQCMAAwKwYDVR0QBCQwIoAPMjAxMDA0MjYxMTU2Mjha
gQ8yMDE0MDQyNjExNTYyOFowCwYDVR0PBAQDAgWgMBMGA1UdJQQMMAoGCCsGAQUFBwMBMBEGCWCG
SAGG+EIBAQQEAwIGQDAdBgNVHQ4EFgQUZ4lmkZuyaY2TQ0J4JfUzHFLOrn4wHwYDVR0jBBgwFoAU
QJp2RJd0B8SsFMsejU86RXww12EwWwYDVR0fBFQwUjBQoE6gTKRKMEgxCzAJBgNVBAYTAkVTMQ0w
CwYDVQQKEwRGTk1UMRgwFgYDVQQLEw9GTk1UIENsYXNlIDIgQ0ExEDAOBgNVBAMTB0NSTDcxMDEw
DQYJKoZIhvcNAQEFBQADgYEAFAQHmluSpnNPMyR+VBVzLYnYY0usQnfUUSyRNFTbBtedqjvcua5A
Lf07pd7TpaevZRcGLksoxojKP/J3N5dWlNL0o7WcTpFpL5Fzs+54v4eiBFG6yWy3zi+9O3EAdsR5
elEjVTg64XMJSQi9/R8COb5HEt9mfHQnI5nbYuGlXng=</ds:X509Certificate>
        </ds:X509Data>
        <ds:KeyValue>
          <ds:RSAKeyValue>
            <ds:Modulus>4DpH4O05vkTj4IWyo/ErY4poauqaI/uU/pJap3an0waePLdxm4p4VgI/zc/nOLGJoF7ZI1zMf01I
CwcGTgklWB/UTGyLNZtgv8vi3wAfSEasWRoLuSzJ+gnIJ2GBuIkyr88HdD52XVNl2IMPNlf9Vg3l
crzu6oAok4dRLZYmQJc=</ds:Modulus>
            <ds:Exponent>AQAB</ds:Exponent>
          </ds:RSAKeyValue>
        </ds:KeyValue>
      </ds:KeyInfo>
    </ds:Signature>
  </soapenv:Header>
  <soapenv:Body Id="Body">
    <n5:Respuesta xmlns:n5="http://intermediacion.redsara.es/scsp/esquemas/V3/respuesta">
      <n5:Atributos>
        <n5:IdPeticion>341_SPP_MINHAP_VERRES_0022</n5:IdPeticion>
        <n5:NumElementos>1</n5:NumElementos>
        <n5:TimeStamp>2013-02-26T16:24:19.019+01:00</n5:TimeStamp>
        <n5:Estado>
          <n5:CodigoEstado>0003</n5:CodigoEstado>
          <n5:CodigoEstadoSecundario />
          <n5:LiteralError>Tramitada</n5:LiteralError>
          <n5:TiempoEstimadoRespuesta>0</n5:TiempoEstimadoRespuesta>
        </n5:Estado>
        <n5:CodigoCertificado>SVDRWS01</n5:CodigoCertificado>
      </n5:Atributos>
      <n5:Transmisiones>
        <n5:TransmisionDatos>
          <n5:DatosGenericos>
            <n5:Emisor>
              <n5:NifEmisor>S2833002E</n5:NifEmisor>
              <n5:NombreEmisor>MINISTERIO DE HACIENDA Y AP</n5:NombreEmisor>
            </n5:Emisor>
            <n5:Solicitante>
              <n5:IdentificadorSolicitante>S2833002E</n5:IdentificadorSolicitante>
              <n5:NombreSolicitante>MINISTERIO DE HACIENDA Y AP</n5:NombreSolicitante>
              <n5:Finalidad>PRUEBAS DE INTEGRACION SVDR</n5:Finalidad>
              <n5:Consentimiento>Si</n5:Consentimiento>
            </n5:Solicitante>
            <n5:Titular>
              <n5:TipoDocumentacion>NIF</n5:TipoDocumentacion>
              <n5:Documentacion>10000322Z</n5:Documentacion>
              <n5:Nombre>MANUELA</n5:Nombre>
              <n5:Apellido1>BLANCO</n5:Apellido1>
              <n5:Apellido2>VIDAL</n5:Apellido2>
            </n5:Titular>
            <n5:Transmision>
              <n5:CodigoCertificado>SVDRWS01</n5:CodigoCertificado>
              <n5:IdSolicitud>341_SPP_MINHAP_VERRES_0022</n5:IdSolicitud>
              <n5:IdTransmision>SPP0000000111955</n5:IdTransmision>
              <n5:FechaGeneracion>2013-02-26T16:24:19.014+01:00</n5:FechaGeneracion>
            </n5:Transmision>
          </n5:DatosGenericos>
          <ns7:DatosEspecificos xmlns:ns7="http://intermediacion.redsara.es/scsp/esquemas/datosespecificos">
            <ns7:Retorno>
              <ns7:Estado>
                <ns7:CodigoEstado>0003</ns7:CodigoEstado>
                <ns7:LiteralError>Tramitada</ns7:LiteralError>
              </ns7:Estado>
            </ns7:Retorno>
          </ns7:DatosEspecificos>
        </n5:TransmisionDatos>
      </n5:Transmisiones>
    </n5:Respuesta>
  </soapenv:Body>
</soapenv:Envelope>
EOSOAP
  end

end
