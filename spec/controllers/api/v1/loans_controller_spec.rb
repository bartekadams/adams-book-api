require 'rails_helper'

RSpec.describe Api::V1::LoansController, type: :controller do
    describe "GET #my_requests" do
        it "returns a 200 OK status" do
            get :my_requests
            expect(response).to have_http_status(:unauthorized)
        end
    end
end
