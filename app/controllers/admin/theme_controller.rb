module Admin
  class ThemeController < BaseController
    def show
      @grouped_settings = ThemeSetting::GROUPS.each_with_object({}) do |group, hash|
        settings = ThemeSetting.by_group(group)
        hash[group] = settings if settings.any?
      end
    end

    def update
      params[:theme]&.each do |key, value|
        ThemeSetting.set(key, value)
      end

      # Handle boolean checkboxes (unchecked ones won't be in params)
      ThemeSetting.where(setting_type: "boolean").find_each do |setting|
        unless params[:theme]&.key?(setting.key)
          setting.update(value: "false")
        end
      end

      redirect_to admin_theme_path, notice: "Appearance settings saved successfully."
    end
  end
end
