module ResidenceVerification
  module Rq
    # Peticion/Solicitudes/SolicitudTransmision/DatosGenericos/Titular
    class Titular
      attr_reader :doc_type, :doc_number, :surname
      # municipio is not used to generate the contents of the Titular,
      # but to be carryed out for other classes to use it.
      attr_accessor :municipio

      # Parameters:
      # - doc_type: One of: :nif, :dni, :passport, :nie
      # - doc_number: The document number
      # - surname: Primer apellido
      # - municipio: Municipality introduced by the citizen, optional.
      def initialize(doc_type, doc_number, surname, municipio)
        @doc_type= doc_type
        @doc_number= doc_number
        @surname= surname
        @municipio= municipio
      end

      def to_h
        {
          tipoDocumentacion: tipo_documentacion,
          documentacion: doc_number,
          apellido1: surname&.upcase
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