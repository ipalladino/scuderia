class Order < ActiveRecord::Base
  #publish type is 0 for 250
  #publish type is 1 for 150
  #publish type is 2 for 90

  attr_accessor :card_number, :card_verification, :promo_code_id
  attr_accessible :card_expires_on, :card_type, :ferrari_id, :first_name, :ip_address, :last_name, :card_number, :card_verification, :promo_code_id, :publish_setting, :promo_code_id
  belongs_to :ferrari
  has_many :transactions, :class_name => "OrderTransaction"

  validate :validate_card, :on => :create

  def purchase
    response = GATEWAY.purchase(price_in_cents, credit_card, ip: ip_address)
    transactions.create!(:action => "purchase", :amount => price_in_cents, :response => response)
    ferrari.update_attribute(:published_at, Time.now) if response.success?
    response.success?
  end

  def price_in_cents
    promo_modifier = 1
    if(promo_code)
      promo_modifier = promo_code.discount_type
    end

    if(publish_setting == 0)
      price = 250*promo_modifier
    elsif(publish_setting == 1)
      price = 150*promo_modifier
    elsif(publish_setting == 2)
      price = 90*promo_modifier
    else
      return false
    end

    (price*100).round
  end

  def promo_code
    begin
      PromoCode.find(promo_code_id)
    rescue
      return nil
    end
  end

  private

  def validate_card
    unless credit_card.valid?
      credit_card.errors.full_messages.each do |message|
        errors.add :base, message
      end
    end
  end

  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
      :brand              => card_type,
      :number             => card_number,
      :verification_value => card_verification,
      :month              => card_expires_on.month,
      :year               => card_expires_on.year,
      :first_name         => first_name,
      :last_name          => last_name
    )
  end

  def verifyPromoCode
    return true
  end

end
