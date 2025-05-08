require "rails_helper"

RSpec.describe Date do
  describe "#to_relative_in_words" do
    subject(:relative_date_in_words) { date.to_relative_in_words }

    let(:date) { described_class.new(1995, 12, 21) }

    it { is_expected.to be_an_instance_of(String) }

    it "contains the abbreviated name of the day of the week" do
      expect(relative_date_in_words).to include(t("date.abbr_day_names")[date.wday])
    end

    it "contains the day of the month" do
      expect(relative_date_in_words).to include(date.day.to_s)
    end

    it "contains the abbreviated name of the month" do
      expect(relative_date_in_words).to include(t("date.abbr_month_names")[date.month])
    end

    context "when the date is not in the current year" do
      it "contains the year" do
        expect(relative_date_in_words).to include(date.year.to_s)
      end
    end

    context "when the date is in the current year" do
      let(:date) { described_class.current.beginning_of_year }

      it "does not contain the year" do
        expect(relative_date_in_words).not_to include(date.year.to_s)
      end
    end

    context "when date is today" do
      let(:date) { described_class.current }

      it { is_expected.to eql(t("date.today")) }
    end

    context "when date is yesterday" do
      let(:date) { described_class.yesterday }

      it { is_expected.to eql(t("date.yesterday")) }
    end
  end

  describe "#current_year?" do
    subject { date.current_year? }

    context "when the date is in the current year" do
      let(:date) { described_class.current }

      it { is_expected.to be(true) }
    end

    context "when the date is not in the current year" do
      let(:date) { described_class.current.prev_year }

      it { is_expected.to be(false) }
    end
  end
end
