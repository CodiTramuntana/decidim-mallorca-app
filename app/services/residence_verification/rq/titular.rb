module ResidenceVerification
  module Rq
    # Peticion/Solicitudes/SolicitudTransmision/DatosGenericos/Titular
    class Titular
      attr_reader :doc_type, :municipality_code

      # Parameters:
      # - doc_type: One of: :nif, :dni, :passport, :nie
      # - doc_number: The document number
      # - municipality_code: INE municipality code
      def initialize(doc_type, doc_number, municipality_code)
        @doc_type= doc_type
        @doc_number= doc_number
        @municipality_code= municipality_code
      end

      def to_h
        {
          TipoDocumentacion: tipo_documentacion,
          Documentacion: @doc_number,
        }
      end

      def tipo_documentacion
        case @doc_type
        when :nif then "NIF"
        when :dni then "DNI"
        when :passport then "Pasaporte"
        when :nie then "NIE"
        else
          raise "Unknown doc_type: #{@doc_type}"
        end
      end

      #-----------------------------------
      private
      #-----------------------------------


    end
  end
end
