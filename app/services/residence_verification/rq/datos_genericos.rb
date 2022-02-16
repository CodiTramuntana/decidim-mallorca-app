module ResidenceVerification
  module Rq
    # Peticion/Solicitudes/SolicitudTransmision/DatosGenericos
    class DatosGenericos
      def initialize(rq_id, titular)
        @rq_id= rq_id
        @titular= titular
      end

      def to_h
        {
          Emisor: {NifEmisor: "S2833002E", NombreEmisor: nombre_emisor},
          Solicitante: {
            IdentificadorSolicitante: nif_del_organismo,
            NombreSolicitante: nombre_solicitante,
            UnidadTramitadora: unidad_tramitadora,
            Procedimiento: {
              CodProcedimiento: cod_procedimiento,
              NombreProcedimiento: nombre_procedimiento
            },
            Finalidad: finalidad,
            Consentimiento: "Si",
          },
          Titular: @titular.to_h,
          Transmision: {CodigoCertificado: ResidenceVerification::Rq::SoapBody::CODIGO_CERTIFICADO, IdSolicitud: @rq_id}
        }
      end

      #-----------------------------------
      private
      #-----------------------------------

      def nombre_emisor
        "Ministerio de Hacienda y Administraciones Públicas"
      end

      def nif_del_organismo
        "S0711001H"
      end

      # Nombre o razón social del organismo
      def nombre_solicitante
        "CONSELL INSULAR DE MALLORCA"
      end

      # Unidad Tramitadora a la que pertenece la persona o aplicación que solicita los datos.
      def unidad_tramitadora
        "DIRECCIO INSULAR DE PARTICIPACIO"
      end

      # Cóigo del Procedimiento que autoriza al usuario a realizar la consulta.
      def cod_procedimiento
        "CODSVDA_GBA_20131008"
      end

      # Nombre del Procedimiento que autoriza al usuario a realizar la consulta.
      def nombre_procedimiento
        if Rails.env.production?
          "CONSULTA PARA GOBIERNO DE BALEARES"
        else
          "PRUEBAS DE INTEGRACION PARA GOBIERNO DE BALEARES"
        end
      end

      # Contiene el motivo o causa por la que se necesita realizar la verificación de datos de residencia.
      def finalidad
        "Poder participar en la plataforma de participación del Consell de Mallorca"
      end
    end
  end
end
