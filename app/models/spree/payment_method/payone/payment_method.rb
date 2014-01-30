# Spree payment method which covers general PAYONE operations.
#
# This class must not be instantiate. It is used to gather all common settings
# for Spree PAYONE payment method.
module Spree
  class PaymentMethod::PAYONE::PaymentMethod < PaymentMethod
    delegate_belongs_to :provider, :authorize, :purchase, :capture, :void, :credit
    
    # Payment method preferences
    preference :use_global_account_settings, :boolean, :default => true
    preference :merchant_id, :string
    preference :payment_portal_id, :string
    preference :payment_portal_key, :string
    preference :sub_account_id, :string
    preference :test_mode, :boolean, :default => true
    preference :currency_code, :string, :default => 'EUR'
    
    # Preferences accessors
    #attr_accessible :preferred_use_global_account_settings
    #attr_accessible :preferred_merchant_id
    #attr_accessible :preferred_payment_portal_id
    #attr_accessible :preferred_payment_portal_key
    #attr_accessible :preferred_sub_account_id
    #attr_accessible :preferred_test_mode
    #attr_accessible :preferred_currency_code
    
    # Instantiates the selected payment method and configures with the options stored in the database.
    def self.current
      super
    end
    
    # Instantiates the provider class.
    def provider
      gateway_options = options
      gateway_options.delete :login if gateway_options.has_key?(:login) and gateway_options[:login].nil?
      ActiveMerchant::Billing::Base.gateway_mode = gateway_options[:server].to_sym
      @provider ||= provider_class.new(gateway_options)
    end

    def options
      options_hash = {}
      self.preferences.each do |key, value|
        options_hash[key.to_sym] = value
      end
      options_hash[:server] = 'test'
      if options_hash.has_key?(:test_mode) and options_hash[:test_mode] == false
        options_hash[:server] = 'active'
      end
      options_hash
    end

    def method_missing(method, *args)
      if @provider.nil? || !@provider.respond_to?(method)
        super
      else
        provider.send(method)
      end
    end
    
    # Returns profiles storage support (PAYONE on-site storage not supported).
    def payment_profiles_supported?
      false
    end
    
    # Returns true if confirmation needed before processing the payment.
    def payment_confirmation_required?
      false
    end
  end
end
