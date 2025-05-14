RSpec.shared_examples "of squished name" do
  it "does not contain whitespace on the left and right" do
    object.name = "\t\n\v\f\r name \t\n\v\f\r"
    expect(name).to eql("name")
  end

  it "can contain only one space character between non whitespace characters" do
    object.name = "na \t \n \v \f \r me"
    expect(name).to eql("na me")
  end
end

RSpec.shared_examples "it has name" do
  let(:essence) { described_class.to_s.underscore.to_sym }
  let(:object) { build(essence) }

  describe "#name" do
    subject(:name) { object.name }

    it { is_expected.to be_an_instance_of(String) }

    it "cannot be absent" do
      expect(build(essence, name: nil)).not_to be_valid
    end

    it "cannot be empty" do
      expect(build(essence, name: "")).not_to be_valid
    end

    include_examples "of squished name"
  end
end

RSpec.shared_examples "of currency available to use" do |attribute|
  let(:essence) { described_class.to_s.underscore.to_sym }

  it { is_expected.to be_an_instance_of(Money::Currency) }

  it "cannot be absent" do
    expect(build(essence, attribute => nil)).not_to be_valid
  end

  it "can be only `USD`, `EUR` or `RUB`" do
    expect(build(essence, attribute => Money::Currency.new("USD"))).to be_valid
    expect(build(essence, attribute => "EUR")).to be_valid
    expect(build(essence, attribute => :rub)).to be_valid
    expect(build(essence, attribute => "GBP")).not_to be_valid
    expect(build(essence, attribute => "ABC")).not_to be_valid
  end
end

RSpec.shared_examples "it has timestamps" do
  let(:essence) { described_class.to_s.underscore.to_sym }

  describe "#created_at" do
    subject { build_stubbed(essence).created_at }

    it { is_expected.to be_an_instance_of(ActiveSupport::TimeWithZone) }
  end

  describe "#updated_at" do
    subject { build_stubbed(essence).updated_at }

    it { is_expected.to be_an_instance_of(ActiveSupport::TimeWithZone) }
  end
end
