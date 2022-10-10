# frozen_string_literal: true

#
# A set of utils to manage and validate verification related data.
#
namespace :residence_verification do
  desc "Checks the given credentials against the census_api (document_type dni/nie/passport, birthdate yyyy/mm/dd)"
  task :check, [:document_type, :document_number, :municipality_code] => :environment do |_task, args|
    document_type= args.document_type
    document_number= args.document_number
    municipality_code= args.municipality_code

    puts <<~EOMSG
      Performing request with parameters:
      document_type: #{document_type}
      document_number: #{document_number}
      municipality_code: #{municipality_code}
    EOMSG

    client= ResidenceVerification::Client.new
    rs_body= client.send_request(document_type, document_number, municipality_code)

    puts "\nRESPONSE:"
    puts "RS: #{rs_body}"
  end
end