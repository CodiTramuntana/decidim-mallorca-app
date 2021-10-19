module ResidenceVerification
  module Rq
    # Peticion/Atributos
    class Atributos
      def initialize(rq_id, rq_timestamp)
        @rq_timestamp= rq_timestamp
        @rq_id= rq_id
      end

      def to_h
        {
          IdPeticion: @rq_id,
          NumElementos: 1,
          TimeStamp: timestamp,
          CodigoCertificado: ResidenceVerification::Rq::SoapBody::CODIGO_CERTIFICADO,
        }
      end

      #-----------------------------------
      private
      #-----------------------------------

      # Format: `AAAA-MM-DDThh:mm:ss.mmm[+|-]hh:mm`
      def timestamp
        @rq_timestamp.strftime("%Y-%m-%dT%H:%M:%S.%L%Z")
      end

    end
  end
end
