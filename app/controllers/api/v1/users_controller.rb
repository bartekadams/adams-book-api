class Api::V1::UsersController < ApplicationController
    def register
        user = User.new(user_params)
        if user.save
            render json: {
                status: "SUCCESS",
                message: "User created"
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
        user = User.find_by(username: params[:username])
        if user
            render json: {
                status: "SUCCESS",
                message: "User logged in",
                token: "TEMP"
            }, status: :ok
        else
            render json: {
                status: "ERROR",
                message: "User not found"
            }, status: :not_found
        end
    end

    private
    def user_params
        params.permit(:username, :password, :password_confirmation)
    end
end
