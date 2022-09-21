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
        {
          datosGenericos: ResidenceVerification::Rq::DatosGenericos.new(@organization, @rq_id, @titular).to_h,
          # datosEspecificos: ResidenceVerification::Rq::DatosEspecificos.new(@titular).to_h,
          datosEspecificos: "<?xml version=\"1.0\" encoding=\"UTF-8\"?><ns1:DatosEspecificos xmlns:ns1=\"http://intermediacion.redsara.es/scsp/esquemas/datosespecificos\"></ns1:DatosEspecificos>",
        }
      end
    end
  end
end
