class CapitalController < ApplicationController
  def show
    @accounting = Accounting.new(user: current_user, **accounting_params)

    @total_funds = @accounting.total_funds
    @incomes_amount = @accounting.incomes_amount
    @expenses_amount = @accounting.expenses_amount
  end

  private

  def accounting_params
    params[:accounting]&.permit(%i[currency from to]) || {}
  end
end
