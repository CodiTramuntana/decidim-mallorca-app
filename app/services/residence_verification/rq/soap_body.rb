module ResidenceVerification
  module Rq
    class SoapBody
      CODIGO_CERTIFICADO= "SVDRWS01"

      def initialize(titular)
        @titular= titular
        @rq_timestamp= Time.zone.now
        @rq_id= "#{ResidenceVerification::Rq::SoapBody::CODIGO_CERTIFICADO}-#{@rq_timestamp.to_i}"
      end

      def to_h
        {
          Peticion: {
            Atributos: ResidenceVerification::Rq::Atributos.new(@rq_id, @rq_timestamp).to_h,
            Solicitudes: [solicitud_transmision],
          }
        }
      end

      #-----------------------------------
      private
      #-----------------------------------

      def solicitud_transmision
        {
          SolicitudTransmision: {
            DatosGenericos: ResidenceVerification::Rq::DatosGenericos.new(@rq_id, @titular).to_h,
            DatosEspecificos: ResidenceVerification::Rq::DatosEspecificos.new(@titular).to_h,
          }
        }
      end
    end
  end
end
