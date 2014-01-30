# Spree payment method which covers PAYONE cash on delivery operations.
#
# Uses ::Spree::PaymentSource::PAYONE::CashOnDelivery for standard
# Spree payment method action implementations.
module Spree
  class PaymentMethod::PAYONE::CashOnDelivery < PaymentMethod::PAYONE::PaymentMethod
    
    # Payment method preferences
    preference :shipping_provider, :string, :default => 'DHL'
    
    # Preferences accessors
    #attr_accessible :preferred_shipping_provider
    
    # Returns provider class responsible for Spree payment method action implementations.
    def provider_class
      ::Spree::PAYONE::Provider::Payment::CashOnDelivery
    end
    
    # Returns payment source class.
    def payment_source_class
      ::Spree::PaymentSource::PAYONE::PayoneCashOnDeliveryPaymentSource
    end
    
    # Redefines method_type which allows to load correct partial template
    # for payment method.
    def method_type
      'payone_cashondelivery'
    end
  end
end
