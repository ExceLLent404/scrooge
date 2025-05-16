require "rails_helper"

RSpec.describe AccountingForm do
  subject(:accounting_form) { described_class.new(from: from_param, to: to_param) }

  let(:from_param) { Faker::Date.between(from: Date.current.beginning_of_year.prev_year, to: to_param) }
  let(:to_param) { Faker::Date.between(from: Date.current.beginning_of_year.prev_year, to: Date.current) }

  it { is_expected.to be_an(ActiveModel::Model) }

  describe "#from" do
    subject(:from) { accounting_form.from }

    it { is_expected.to be_an_instance_of(Date) }

    context "by default" do
      let(:accounting_form) { described_class.new }

      it "is the beginning of the current month" do
        expect(from).to eql(Date.current.beginning_of_month)
      end
    end

    it "cannot be greater than the current date" do
      accounting_form.from = Date.tomorrow
      expect(accounting_form).not_to be_valid
    end

    it "cannot be greater than #to" do
      accounting_form.from = Date.current
      accounting_form.to = Date.yesterday
      expect(accounting_form).not_to be_valid
    end
  end

  describe "#to" do
    subject(:to) { accounting_form.to }

    it { is_expected.to be_an_instance_of(Date) }

    context "by default" do
      let(:accounting_form) { described_class.new }

      it "is the current date" do
        expect(to).to eql(Date.current)
      end
    end

    it "cannot be greater than the current date" do
      accounting_form.to = Date.tomorrow
      expect(accounting_form).not_to be_valid
    end
  end
end
