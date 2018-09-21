class Api::V1::LoansController < ApplicationController
  def index
    render json: {
      status: "SUCCESS",
      message: "Loans found",
      data: {
        loans_as_borrower: current_user.loans_as_borrower,
        loans_as_owner: current_user.loans_as_owner
      }
    }, status: :ok
  end

  def create
    # if request already has been sent to the book owner or book is not set as returned
    # enables loaning same book multiple times after book return
    if current_user.loans.find_by(loan_params.merge status: [:pending, :accepted])
        render json: {
            status: "ERROR",
            message: "Loan not created",
            data: "Book request is active or book is not returned yet"
        }, status: :unprocessable_entity
    else
        loan = current_user.loans.new(loan_params)
        loan.status = :pending
        if loan.save
            render json: {
                status: "SUCCESS",
                message: "Loan created",
                data: loan
            }, status: :created
        else
            render json: {
                status: "ERROR",
                message: "Loan not created",
                data: loan.errors
            }, status: :unprocessable_entity
        end
    end
  end

  def destroy
    loan = Loan.find(params[:id])
    if loan
        unless loan.borrower_id == current_user.id
            render json: {
                status: "ERROR",
                message: "Loan does not belong to you"
            }, status: :forbidden
        else
            render json: {
                status: "SUCCESS",
                message: "Loan deleted",
                data: loan.destroy
            }, status: :ok
        end
    else
        render json: {
            status: "ERROR",
            message: "Loan not found"
        }, status: :not_found
    end
  end

  private
  def loan_params
    params.fetch(:loan, {}).permit(:book_id)
  end
end
