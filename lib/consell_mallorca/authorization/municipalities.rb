require 'csv'

module ConsellMallorca
  module Authorization
    class Municipalities

      # Returns all municipalities of the province of Illes Balears as an array of arrays of name and code.
      def self.all
        # The file contains CMUN, NOMBRE
        CSV.read(Rails.root.join("lib/consell_mallorca/authorization/municipalities.csv"))
      end

    end
  end
end
