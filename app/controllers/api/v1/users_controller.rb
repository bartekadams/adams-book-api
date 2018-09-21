class Api::V1::UsersController < ApplicationController
    skip_before_action :authenticate_request!, only: [:register, :login]

    def register
        user = User.new(user_params)
        if user.save
            payload = { user_id: user.id }
            render json: {
                status: "SUCCESS",
                message: "User created",
                token: JsonWebToken.encode(payload)
            }, status: :created
        else
            render json: {
                status: "ERROR",
                message: "User not created",
                data: user.errors
            }, status: :unprocessable_entity
        end
    end

    def login
        user = User.find_by(username: user_params[:username])
        if user && user.authenticate(user_params[:password])

            payload = { user_id: user.id }

            render json: {
                status: "SUCCESS",
                message: "User logged in",
                token: JsonWebToken.encode(payload)
            }, status: :ok
        else
            render json: {
                status: "ERROR",
                message: "Invalid credentials"
            }, status: :unauthorized
        end
    end

    private
    def user_params
        params.fetch(:user, {}).permit(:username, :password, :password_confirmation)
    end
end
