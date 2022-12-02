module ResidenceVerification
  module Rq
    class DocumentBody
      CODIGO_CERTIFICADO= "SVDDGPCIWS02"
      ID_PETICION_PREFIX= "SVDRWS01"

      def initialize(organization, titular)
        @organization= organization
        @titular= titular
        @rq_timestamp= Time.zone.now
        @rq_id= "#{ResidenceVerification::Rq::DocumentBody::ID_PETICION_PREFIX}-#{@rq_timestamp.to_i}"
      end

      def to_h
        {
          atributos: ResidenceVerification::Rq::Atributos.new(@rq_id, @rq_timestamp).to_h,
          solicitudes: [solicitud_transmision],
        }
      end

      #-----------------------------------
      private
      #-----------------------------------

      def solicitud_transmision
        solicitud= <<-EOEDE
<ns1:Solicitud>
  <ns1:Espanol>s</ns1:Espanol>
  <ns1:Residencia>
    <ns1:Provincia>07</ns1:Provincia>
    <ns1:Municipio>#{municipio}</ns1:Municipio>
  </ns1:Residencia>
</ns1:Solicitud>
EOEDE
        datos_especificos= "<?xml version=\"1.0\" encoding=\"UTF-8\"?><ns1:DatosEspecificos xmlns:ns1=\"http://intermediacion.redsara.es/scsp/esquemas/datosespecificos\">#{solicitud.delete(" \t\r\n")}</ns1:DatosEspecificos>"
        {
          datosGenericos: ResidenceVerification::Rq::DatosGenericos.new(@organization, @rq_id, @titular).to_h,
          datosEspecificos: datos_especificos,
        }
      end

      def municipio
        if @organization.pinbal_municipio.present?
          @organization.pinbal_municipio
        else
          @titular.municipio
        end
      end
    end
  end
end
