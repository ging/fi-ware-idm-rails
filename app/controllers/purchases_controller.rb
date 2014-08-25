# API to the FIWARE OIL Store
#
class PurchasesController < ApplicationController
  respond_to :json

  def create
    purchase = Purchase.new params

    authorize! :create, purchase

    if purchase.save
      head :created
    else
      render json: purchase.errors.full_messages.to_sentence, status: :bad_request
    end
  end
end
