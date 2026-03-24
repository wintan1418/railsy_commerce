module Vendor
  class BaseController < ApplicationController
    before_action :require_vendor

    layout "admin"

    private

    def require_vendor
      redirect_to root_path, alert: "Vendor access required." unless current_user&.vendor? || current_user&.admin?
    end
  end
end
