class CapitalController < ApplicationController
  def show
    zero = Money.zero(current_user.preferred_currency)
    period = Date.current.beginning_of_month..Date.current

    @total_funds = current_user.accounts.sum(zero, &:balance)
    @incomes_amount = current_user.incomes.where(committed_date: period).includes(:destination).sum(zero, &:amount)
    @expenses_amount = current_user.expenses.where(committed_date: period).includes(:source).sum(zero, &:amount)
  end
end
