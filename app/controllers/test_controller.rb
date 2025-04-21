class TestController < ApplicationController
  def index
    flash.now[:notice] = "Notice"
    flash.now[:alert] = "Alert"
  end
end
