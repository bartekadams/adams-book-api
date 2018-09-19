class Api::V1::BooksController < ApplicationController
    def index
        render json: {
            data: Book.limit(10)
        }
    end

    def show
        book = Book.find(params[:id])
        if book
            render json: {
                status: "SUCCESS",
                message: "Book found",
                data: book
            }, status: :ok
        else
            book_not_found
        end
    end

    def create
        book = current_user.books.new(book_params)
        if book.save
            render json: {
                status: "SUCCESS",
                message: "Book created",
                data: book
            }, status: :created
        else
            render json: {
                status: "ERROR",
                message: "Book not created",
                data: book.errors
            }, status: :unprocessable_entity
        end
    end

    def update
        book = Book.find(params[:id])
        if book
            unless book.owner_id == current_user.id
                book_not_yours
            else
                if book.update(book_params)
                    render json: {
                        status: "SUCCESS",
                        message: "Book updated",
                        data: book
                    }, status: :ok
                else
                    render json: {
                        status: "ERROR",
                        message: "Book not updated",
                        data: book.errors
                    }, status: :unprocessable_entity
                end
            end
        else
            book_not_found
        end
    end

    def destroy
        book = Book.find(params[:id])
        if book
            unless book.owner_id == current_user.id
                book_not_yours
            else
                render json: {
                    status: "SUCCESS",
                    message: "Book deleted",
                    data: book.destroy
                }, status: :ok
            end
        else
            book_not_found
        end
    end

    private
    def book_params
        params.require(:book).permit(:name)
    end

    def book_not_found
        render json: {
            status: "ERROR",
            message: "Book not found"
        }, status: :not_found
    end

    def book_not_yours
        render json: {
            status: "ERROR",
            message: "Book does not belong to you"
        }, status: :forbidden
    end
    
end
