class PromoCode < ActiveRecord::Base
  has_many :orders
  attr_accessible :charges, :code

  def discount_type
    if(self.code == 'scuderia101')
      return 0
    elsif(self.code == 'scuderiablogger')
      return 0.50
    else
      return 0.75
    end
  end
end
