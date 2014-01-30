module Spree
  Order.class_eval do
    attr_accessor :redirect_required
    #attr_accessible :blocked_payment_method_types
    
    def blocked_payment_method_types_array
      blocked_payment_method_types.to_s.split(/,/)
    end
    
    def available_payment_methods(display_on = nil)
      blocked = blocked_payment_method_types_array
      PaymentMethod
        .where('type not in (?)', blocked.empty? ? '' : blocked)
        .all(display_on)
    end
    
    def available_payment_methods
      blocked = blocked_payment_method_types_array
      @available_payment_methods ||=
        PaymentMethod
        .where('type not in (?)', blocked.empty? ? '' : blocked)
        .available(:front_end)
    end

    def redirect_required?
      self.redirect_required
    end
    
    Order.state_machines[:state].events[:next].reset
    Order.state_machines[:state].event :next do
      transition :from => "cart",     :to => "address"
      transition :from => "address",  :to => "delivery"
      transition :from => "delivery", :to => "payment", :if => :payment_required?
      transition :from => "delivery", :to => "complete"
      transition :from => "confirm",  :to => "complete"

      # Note: some payment methods will not support a confirm step
      transition :from => "payment",  :to => "confirm",
                                     :if => Proc.new { |order| order.payment_method && order.payment_method.payment_profiles_supported? }
      transition :from => "payment",  :to => "confirm",
                                     :if => Proc.new { |order| order.payment_method && order.payment_method.respond_to?(:payment_confirmation_required?) && order.payment_method.payment_confirmation_required? }

      transition :from => "payment",  :to => "complete"
      
      transition :from => "complete",  :to => "payment_redirect"
      # This action must be performed manualy while we don't want to process payment once again
      # transition :from => :payment_redirect,  :to => :complete
    end
    
    Order.state_machines[:state].before_transition :to => [:delivery] do |order|
      valid = ::Spree::PAYONE::Validators::OrderAddress.validate order
      if valid
        order.shipments.each { |s| s.destroy unless s.shipping_method.available_to_order?(order) }
      else
        valid
      end
    end
    
    Order.state_machines[:state].before_transition :to => :complete do |order|
      begin
        # Decorate the before_transaction and add steps to original order.process_payments!
        order.redirect_required = false
        order.payments.each do |payment|
          if !payment.redirect_url.to_s.empty?
            order.redirect_required = true
            break
          end
        end
        
        # Return true to inform that transition succeeded
        true
      rescue Core::GatewayError
        !!Spree::Config[:allow_checkout_on_gateway_error]
      end
    end
    
    Order.state_machines[:state].before_transition :to => :payment_redirect do |order|
      order.completed_at = ''
    end
  end
end
