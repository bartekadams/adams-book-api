class Api::V1::BooksController < ApplicationController
    def index
        render json: {
            data: Book.limit(10)
        }
    end
    
end
