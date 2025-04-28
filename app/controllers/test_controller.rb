class TestController < ApplicationController
  def index
    @form = TestForm.new.tap { |form| form.validate }
  end
end
