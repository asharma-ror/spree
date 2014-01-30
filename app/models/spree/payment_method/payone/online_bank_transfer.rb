# Spree payment method which covers PAYONE online bank transfer operations.
#
# Uses ::Spree::PaymentSource::PAYONE::OnlineBankTransfer for standard
# Spree payment method action implementations.
module Spree
  class PaymentMethod::PAYONE::OnlineBankTransfer < PaymentMethod::PAYONE::PaymentMethod
    
    # Payment method preferences
    preference :online_bank_transfer_types, :string, :default => 'PNT'
    
    # Preferences accessors
    #attr_accessible :preferred_online_bank_transfer_types
    
    # Returns true if confirmation needed before processing the payment.
    def payment_confirmation_required?
      true
    end
    
    # Returns provider class responsible for Spree payment method action implementations.
    def provider_class
      ::Spree::PAYONE::Provider::Payment::OnlineBankTransfer
    end
    
    # Returns payment source class.
    def payment_source_class
      ::Spree::PaymentSource::PAYONE::PayoneOnlineBankTransferPaymentSource
    end
    
    # Redefines method_type which allows to load correct partial template
    # for payment method.
    def method_type
      'payone_onlinebanktransfer'
    end
  end
end
