class Api::V1::LoansController < ApplicationController

  def create
    # if request already has been sent to the book owner or book is not set as returned
    # enables loaning same book multiple times after book return
    if current_user.loans_as_borrower.find_by(loan_params.merge status: [:pending, :accepted])
        render json: {
            status: "ERROR",
            message: "Loan not created",
            data: "Book request is active or book is not returned yet"
        }, status: :unprocessable_entity
    else
        loan = current_user.loans_as_borrower.new(loan_params)
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

  def update
    loan = Loan.find(params[:id])
    unless loan.book.owner_id == current_user.id
        render json: {
            status: "ERROR",
            message: "You are not the book owner"
        }, status: :forbidden
    else
        if ((loan.status == 'pending' && loan_update_params[:status] == 'accepted' ||
            loan.status == 'accepted' && loan_update_params[:status] == 'returned') &&
            loan.update(loan_update_params))
            render json: {
                status: "SUCCESS",
                message: "Loan updated",
                data: loan
            }, status: :ok
        else
            render json: {
                status: "ERROR",
                message: "Loan not updated",
                data: loan.errors
            }, status: :unprocessable_entity
        end
    end
  end

  def destroy
    loan = Loan.find(params[:id])
    if loan
        unless loan.book.owner.id == current_user.id
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

  def my_requests
    render json: {
        status: "SUCCESS",
        message: "Loans as borrower found",
        data: current_user.loans_as_borrower.joins(:book).select("loans.id, books.name as book_title, books.id as book_id, loans.status, loans.created_at").order('loans.created_at DESC')
    }, status: :ok
  end

  def other_requests
    render json: {
        status: "SUCCESS",
        message: "Loans as owner found",
        data: current_user.loans_as_owner.joins(:borrower, :book).select("loans.id, books.name as book_title, books.id as book_id, loans.status, users.username as borrower_username, loans.created_at").order('loans.created_at DESC')
    }, status: :ok
  end

  private
  def loan_params
    params.fetch(:loan, {}).permit(:book_id)
  end

  def loan_update_params
    params.fetch(:loan, {}).permit(:status)
  end
end
