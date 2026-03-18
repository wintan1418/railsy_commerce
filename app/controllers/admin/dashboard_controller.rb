module Admin
  class DashboardController < BaseController
    def show
      if StoreConfig.get("setup_complete") != "true"
        redirect_to admin_setup_path and return
      end

      result = Analytics::DashboardService.call
      @data = result.payload
    end
  end
end
