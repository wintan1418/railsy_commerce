module Admin
  class SetupController < BaseController
    def show
      redirect_to admin_root_path if setup_complete?
      @step = (params[:step] || "1").to_i
      @step = 1 if @step < 1 || @step > 5
    end

    def update
      step = params[:step].to_i

      case step
      when 1
        save_store_basics
      when 2
        save_payment_settings
      when 3
        save_shipping_settings
      when 4
        save_appearance_settings
      when 5
        StoreConfig.set("setup_complete", "true")
        redirect_to admin_root_path, notice: "Your store is ready! Welcome to RailsyCommerce."
        return
      end

      next_step = step + 1
      if next_step > 5
        StoreConfig.set("setup_complete", "true")
        redirect_to admin_root_path, notice: "Your store is ready! Welcome to RailsyCommerce."
      else
        redirect_to admin_setup_path(step: next_step)
      end
    end

    private

    def setup_complete?
      StoreConfig.get("setup_complete") == "true"
    end

    def save_store_basics
      StoreConfig.set("store_name", params[:store_name]) if params[:store_name].present?
      StoreConfig.set("store_email", params[:store_email]) if params[:store_email].present?
      StoreConfig.set("store_currency", params[:store_currency]) if params[:store_currency].present?
    end

    def save_payment_settings
      StoreConfig.set("stripe_publishable_key", params[:stripe_publishable_key]) if params[:stripe_publishable_key].present?
      StoreConfig.set("stripe_secret_key", params[:stripe_secret_key]) if params[:stripe_secret_key].present?
    end

    def save_shipping_settings
      if params[:shipping_name].present?
        ShippingMethod.find_or_create_by!(name: params[:shipping_name]) do |sm|
          sm.price_cents = (params[:shipping_price].to_f * 100).to_i
          sm.min_delivery_days = params[:min_days].to_i
          sm.max_delivery_days = params[:max_days].to_i
          sm.active = true
        end
      end
    end

    def save_appearance_settings
      ThemeSetting.set("logo_url", params[:logo_url]) if params[:logo_url].present?
      ThemeSetting.set("primary_color", params[:primary_color]) if params[:primary_color].present?
      ThemeSetting.set("secondary_color", params[:secondary_color]) if params[:secondary_color].present?
    end
  end
end
