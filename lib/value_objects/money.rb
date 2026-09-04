class Money
  class InvalidMoneyError < StandardError; end

  attr_reader :amount, :currency

  def self.of(amount, currency)
    validate(amount)
    new(amount, currency)
  end

  def self.validate(amount)
    raise InvalidMoneyError, "Amount cannot be negative" if amount.negative?
  end
  private_class_method :new, :validate

  def initialize(amount, currency)
    @amount = amount
    @currency = currency
  end

  def +(other)
    self.class.of(amount + other.amount, currency)
  end

  def *(multiplier)
    self.class.of(amount * multiplier, currency)
  end

  def zero?
    amount.zero?
  end
end