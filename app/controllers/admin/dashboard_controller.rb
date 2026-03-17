module Admin
  class DashboardController < BaseController
    def show
      result = Analytics::DashboardService.call
      @data = result.payload
    end
  end
end
