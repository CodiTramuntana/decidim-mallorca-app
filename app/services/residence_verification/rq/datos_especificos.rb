module ResidenceVerification
  module Rq
    # Peticion/Solicitudes/SolicitudTransmision/DatosEspecificos
    class DatosEspecificos
      def initialize(titular)
        @titular= titular
      end

      def to_h
        {
          Espanol: es_espanol?,
          Residencia: {
            Provincia: codigo_provincia,
            Municipio: codigo_municipio,
          },
        }
      end

      #-----------------------------------
      private
      #-----------------------------------

      # Indica si la persona de la que se verifican los datos es de nacionalidad española o no.
      # Los valores posibles son: "s" o "n"
      def es_espanol?
        case @titular.tipo_documentacion
        when "NIF", "DNI" then 's'
        when "Pasaporte", "NIE" then 'n'
        else
          raise "Can not determine if es_espanol? for #{@titular.tipo_documentacion}"
        end
      end

      # Código de la Provincia en la que reside el ciudadano.
      # Este campo irá codificado con los códigos del INE (2 dígitos): https://idapadron.ine.es/ape403expl/inicio.menu
      def codigo_provincia
        # The URL https://idapadron.ine.es/ape403expl/inicio.menu does not work
        # Code extracted from: https://www.ine.es/daco/daco42/codmun/cod_provincia.htm
        "07" #  Balears, Illes
      end

      # Código del municipio de residencia del ciudadano.
      # Este campo irá codificado con los códigos del INE (3 dígitos): https://idapadron.ine.es/ape403expl/inicio.menu
      def codigo_municipio
        @titular.municipality_code
      end
    end
  end
end
