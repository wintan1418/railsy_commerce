module Admin
  class SettingsController < BaseController
    def show
      @settings = {
        store_name: StoreConfig.get("store_name"),
        store_currency: StoreConfig.get("store_currency"),
        store_email: StoreConfig.get("store_email"),
        free_shipping_threshold: StoreConfig.get("free_shipping_threshold")
      }
    end

    def update
      params[:settings]&.each do |key, value|
        StoreConfig.set(key, value) if %w[store_name store_currency store_email free_shipping_threshold].include?(key)
      end
      redirect_to admin_settings_path, notice: "Settings saved."
    end
  end
end
