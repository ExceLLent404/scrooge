class CapitalController < ApplicationController
  def show
    @accounting_form = AccountingForm.new(accounting_params)
    zero = Money.zero(current_user.preferred_currency)

    @total_funds = current_user.accounts.sum(zero, &:balance)

    if @accounting_form.valid?
      period = @accounting_form.from..@accounting_form.to

      @incomes_amount = current_user.incomes.where(committed_date: period).includes(:destination).sum(zero, &:amount)
      @expenses_amount = current_user.expenses.where(committed_date: period).includes(:source).sum(zero, &:amount)
    else
      @incomes_amount = zero
      @expenses_amount = zero
    end
  end

  private

  def accounting_params
    params[:accounting_form]&.permit(%i[from to]) || {}
  end
end
