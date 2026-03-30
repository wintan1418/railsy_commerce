module Rider
  class BaseController < ApplicationController
    before_action :require_rider

    layout "rider"

    private

    def require_rider
      redirect_to root_path, alert: "Rider access required." unless current_user&.rider? || current_user&.admin?
    end
  end
end
