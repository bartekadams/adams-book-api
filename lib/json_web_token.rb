class JsonWebToken
    def self.encode(payload)
        payload.merge!(meta)
        hmac_secret = Rails.application.secrets.secret_key_base
        JWT.encode payload, hmac_secret, 'HS256'
    end

    def self.decode(token)
        hmac_secret = Rails.application.secrets.secret_key_base
        JWT.decode token, hmac_secret, true, { algorithm: 'HS256' }
    end

    private
    def self.meta
        {
            exp: 7.days.from_now.to_i
        }
    end
end