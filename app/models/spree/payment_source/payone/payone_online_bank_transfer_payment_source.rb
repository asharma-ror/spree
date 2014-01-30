# Spree payment method source for PAYONE online bank transfer.
module Spree
  module PaymentSource
    module PAYONE
      class PayoneOnlineBankTransferPaymentSource < ActiveRecord::Base
        has_many :payments, :as => :source
        
        #attr_accessible :first_name, :last_name, :online_bank_transfer_type, :bank_country,
                        #:bank_account, :bank_code, :bank_group_type
        
        # Lists available actions.
        def actions
          %w{capture void credit}
        end
        
        # Indicates whether its possible to capture the payment.
        def can_capture?(payment)
          payment.state == 'pending' || payment.state == 'checkout'
        end
        
        # Indicates whether its possible to void the payment.
        def can_void?(payment)
          payment.state != 'void' && payment.state != 'completed' && payment.state != 'failed' && payment.state != 'processing'
        end
        
        # Indicates whether its possible to credit the payment.
        def can_credit?(payment)
          return false unless payment.state == 'completed'
          return false unless payment.order.payment_state == 'credit_owed'
          payment.credit_allowed > 0
        end
      end
    end
  end
end
