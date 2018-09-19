class ApplicationController < ActionController::API
    rescue_from ActiveRecord::RecordNotFound, :with => :not_found_handler

    def not_found_handler(e)
        render json: {
            status: "ERROR",
            message: "Record with this id not found",
            data: e
        }, status: :not_found
    end
end
