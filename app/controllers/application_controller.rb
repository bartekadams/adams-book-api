class ApplicationController < ActionController::API
    before_action :authenticate_request!

    rescue_from ActiveRecord::RecordNotFound, with: :not_found_handler
    rescue_from JWT::DecodeError, JWT::VerificationError, JWT::ExpiredSignature, with: :token_error

    attr_reader :current_user

    protected
    def authenticate_request!
        user_id = JsonWebToken.decode(get_token_from_headers)[0]['user_id']
        @current_user = User.find(user_id)
    end

    private
    def token_error(e)
        render json: { status: "ERROR", message: e.to_s }, status: :unauthorized
    end

    def not_found_handler(e)
        render json: {
            status: "ERROR",
            message: e
        }, status: :not_found
    end

    def get_token_from_headers
        auth_header = request.headers['Authorization']
        if auth_header
            token = auth_header.split(' ').last
        end
    end

end
