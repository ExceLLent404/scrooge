class TestController < ApplicationController
  def index
    @form = TestForm.new.tap { |form| form.validate }
    flash.now[:notice] = "Notice"
    flash.now[:alert] = "Alert"
  end
end
