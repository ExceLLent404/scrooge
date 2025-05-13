class Operation
  extend Dry::Initializer[undefined: false]
  include Dry::Monads[:result, :do, :try]

  def self.call(...)
    new(...).call
  end
end
