require 'aws-sdk-kms'
require 'base64'

require_relative 'configuration'
require_relative 'error'

module Perambulator
  class Encryption
    class DecryptionError < Perambulator::Error; end

    class << self
      def encrypt(payload, kms_key_arn: nil, aws_region: nil, aws_credentials: nil)
        kms_key_arn ||= Perambulator.config.kms.key_arn
        response = client(aws_region, aws_credentials).encrypt(
          key_id: kms_key_arn,
          plaintext: payload
        )
        Base64.urlsafe_encode64(response.ciphertext_blob)
      end

      def decrypt(payload, aws_region: nil, aws_credentials: nil)
        return nil if payload.nil?
        return nil if payload.length.zero?

        raw_payload = decode_payload(payload)

        response = client(aws_region, aws_credentials).decrypt(
          ciphertext_blob: raw_payload
        )
        response.plaintext
      rescue Aws::KMS::Errors::ServiceError => error
        message = if error.message&.length&.positive?
                    error.message
                  else
                    error.class.name
                  end
        raise Perambulator::Encryption::DecryptionError, message
      end

      def try_decrypt(*args)
        decrypt(*args)
      rescue Perambulator::Encryption::DecryptionError
        nil
      end

      private

      def decode_payload(payload)
        Base64.urlsafe_decode64(payload)
      rescue ArgumentError => error
        raise Perambulator::Encryption::DecryptionError, error.message
      end

      def client(region, credentials)
        Aws::KMS::Client.new(
          region: region || Perambulator.config.aws.region,
          credentials: credentials || Perambulator.config.aws.credentials
        )
      end
    end
  end
end
