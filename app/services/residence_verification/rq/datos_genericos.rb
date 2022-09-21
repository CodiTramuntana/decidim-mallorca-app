module ResidenceVerification
  module Rq
    # Peticion/Solicitudes/SolicitudTransmision/DatosGenericos
    class DatosGenericos
      def initialize(organization, rq_id, titular)
        @organization= organization
        @rq_id= rq_id
        @titular= titular
      end

      def to_h
        {
          emisor: {nifEmisor: "S2833002E", nombreEmisor: nombre_emisor},
          solicitante: {
            identificadorSolicitante: nif_del_organismo,
            nombreSolicitante: nombre_solicitante,
            unidadTramitadora: unidad_tramitadora,
            procedimiento: {
              codProcedimiento: cod_procedimiento,
              nombreProcedimiento: nombre_procedimiento
            },
            funcionario: {nombreCompletoFuncionario: nombre_completo_funcionario, nifFuncionario: nif_funcionario},
            idExpediente: id_expediente,
            finalidad: finalidad,
            consentimiento: consentimiento,
          },
          titular: @titular.to_h,
          # Transmision: {CodigoCertificado: ResidenceVerification::Rq::DocumentBody::CODIGO_CERTIFICADO, IdSolicitud: @rq_id}
        }
      end

      #-----------------------------------
      private
      #-----------------------------------

      def nombre_emisor
        "Ministerio de Hacienda y Administraciones Públicas"
      end

      def nif_del_organismo
        Rails.application.secrets.pinbal_solicitante_identificador_solicitante
      end

      # Nombre o razón social del organismo
      def nombre_solicitante
        Rails.application.secrets.pinbal_solicitante_nombre_solicitante
      end

      # Unidad Tramitadora a la que pertenece la persona o aplicación que solicita los datos.
      def unidad_tramitadora
        Rails.application.secrets.pinbal_solicitante_unidad_tramitadora
      end

      # Cóigo del Procedimiento que autoriza al usuario a realizar la consulta.
      def cod_procedimiento
        Rails.application.secrets.pinbal_solicitante_cod_procedimiento
      end

      # Nombre del Procedimiento que autoriza al usuario a realizar la consulta.
      def nombre_procedimiento
        Rails.application.secrets.pinbal_solicitante_nombre_procedimiento
      end

      def nombre_completo_funcionario
        Rails.application.secrets.pinbal_solicitante_nombre_completo_funcionario
      end

      def nif_funcionario
        Rails.application.secrets.pinbal_solicitante_nif_funcionario
      end

      def id_expediente
        Rails.application.secrets.pinbal_solicitante_id_expediente
      end

      # Contiene el motivo o causa por la que se necesita realizar la verificación de datos de residencia.
      def finalidad
        Rails.application.secrets.pinbal_solicitante_finalidad
      end

      def consentimiento
        Rails.application.secrets.pinbal_solicitante_consentimiento
      end
    end
  end
end
