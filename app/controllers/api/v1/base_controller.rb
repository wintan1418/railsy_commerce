module Api
  module V1
    class BaseController < ActionController::API
      before_action :authenticate_api_user!

      private

      def authenticate_api_user!
        token = request.headers["Authorization"]&.gsub(/^Bearer\s+/, "")
        @current_session = Session.find_by(id: token) if token.present?
        render_unauthorized unless @current_session
      end

      def current_user
        @current_session&.user
      end

      def render_unauthorized
        render json: { error: "Unauthorized" }, status: :unauthorized
      end

      def render_not_found
        render json: { error: "Not found" }, status: :not_found
      end

      def render_unprocessable(errors)
        render json: { errors: Array(errors) }, status: :unprocessable_entity
      end
    end
  end
end
