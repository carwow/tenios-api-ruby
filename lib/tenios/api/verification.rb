module Tenios
  module API
    class Verification
      attr_reader :client

      def initialize(client)
        @client = client
      end

      DOCUMENT_TYPES = %w[
        ALLOCATION_NOTICE
        IDENTITY_CARD
        BUSINESS_LICENSE
        IDENTITY_CARD_AND_BUSINESS_LICENSE
        CERTIFICATE_OF_REGISTRATION
        CONTRACT
      ].freeze

      def create(options)
        payload = build_payload(options)
        client.http_client.post('/verification/create', payload).body
      end

      private

      OPTIONS = %i[
        area_code
        city
        country
        document_data
        document_type
        house_number
        street
      ].freeze
      private_constant :OPTIONS

      def build_payload(options)
        to_option = build_option(options)

        { access_key: client.access_key }
          .merge(OPTIONS.map(&to_option).to_h)
          .to_json
      end

      def build_option(options)
        lambda do |name|
          value = options.fetch(name)
          validate = :"validate_#{name}!"
          send validate, value if respond_to? validate, true
          [name, value]
        end
      end

      def validate_document_type!(type)
        return if DOCUMENT_TYPES.include? type

        raise ArgumentError, "invalid document_type: #{type}"
      end
    end
  end
end
