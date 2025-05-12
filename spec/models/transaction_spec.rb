require "rails_helper"

RSpec.describe Transaction do
  subject(:transaction) { build(:transaction) }

  it { is_expected.to be_an(ApplicationRecord) }

  it "cannot be abstract" do
    expect { described_class.new }.to raise_error(ActiveRecord::SubclassNotFound)
    expect { described_class.new(type: nil) }.to raise_error(ActiveRecord::SubclassNotFound)
    expect { described_class.new(type: "") }.to raise_error(ActiveRecord::SubclassNotFound)

    expect(described_class.new(type: "Income")).to be_an_instance_of(Income)
    expect(described_class.new(type: "Expense")).to be_an_instance_of(Expense)
  end

  it { is_expected.to monetize(:amount) }

  it_behaves_like "it has timestamps"

  describe "#type" do
    subject { transaction.type }

    it { is_expected.to be_an_instance_of(String) }

    it "cannot be blank" do
      transaction.type = nil
      expect(transaction).not_to be_valid

      transaction.type = ""
      expect(transaction).not_to be_valid
    end

    it "can be only `Income` or `Expense`" do
      expect(build(:transaction, type: "Income")).to be_valid
      expect(build(:transaction, type: "Expense")).to be_valid
      expect { build(:transaction, type: "SomeOtherType") }.to raise_error(ActiveRecord::SubclassNotFound)
    end

    it "cannot be changed for persisted instance" do
      transaction = build_stubbed(:transaction)

      expect { transaction.type = "NewType" }.to raise_error(ActiveRecord::ReadonlyAttributeError)
      expect { transaction.attributes = {type: "NewType"} }.to raise_error(ActiveRecord::ReadonlyAttributeError)
    end
  end

  describe "#amount_cents" do
    subject(:amount_cents) { transaction.amount_cents }

    it { is_expected.to be_an_instance_of(Integer) }

    it "cannot be absent" do
      expect(build(:transaction, amount_cents: nil)).not_to be_valid
    end

    it "is > 0" do
      expect(amount_cents).to be > 0
      expect(build(:transaction, amount_cents: 0)).not_to be_valid
    end
  end

  describe "#amount" do
    subject(:amount) { transaction.amount }

    it { is_expected.to be_an_instance_of(Money) }

    it "is > 0" do
      expect(amount).to be > 0
      expect(build(:transaction, amount: 0)).not_to be_valid
    end
  end

  describe "#comment" do
    subject(:comment) { transaction.comment }

    it { is_expected.to be_an_instance_of(String).or(be_nil) }

    it "cannot be empty" do
      transaction.comment = ""
      expect(comment).to be_nil
    end

    it "does not contain whitespace on the left and right" do
      transaction.comment = "\t\n\v\f\r comment \t\n\v\f\r"
      expect(comment).to eql("comment")
    end
  end

  describe "#committed_date" do
    subject { build(:transaction).committed_date }

    it { is_expected.to be_an_instance_of(Date) }

    it "cannot be absent" do
      expect(build(:transaction, committed_date: nil)).not_to be_valid
    end
  end

  describe "Associations" do
    describe "#source" do
      subject(:source) { transaction.source }

      it "belongs to the same user as the transaction itself" do
        expect(transaction).to be_valid
        expect(source.user).to eql(transaction.user)

        source.user = build(:user)
        expect(transaction).not_to be_valid

        source.user = transaction.user
        source.user_id = 1
        expect(transaction).not_to be_valid
      end
    end

    describe "#destination" do
      subject(:destination) { transaction.destination }

      it "belongs to the same user as the transaction itself" do
        expect(transaction).to be_valid
        expect(destination.user).to eql(transaction.user)

        destination.user = build(:user)
        expect(transaction).not_to be_valid

        destination.user = transaction.user
        destination.user_id = 1
        expect(transaction).not_to be_valid
      end
    end
  end
end
