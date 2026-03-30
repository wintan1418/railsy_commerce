module Admin
  class ImportsController < BaseController
    def new
    end

    def create
      unless params[:file].present?
        redirect_to new_admin_import_path, alert: "Please select a CSV file."
        return
      end

      result = Products::ImportService.call(file: params[:file])

      if result.success?
        redirect_to admin_products_path,
          notice: "Imported #{result.payload[:success_count]} products. #{result.payload[:error_count]} errors."
      else
        redirect_to new_admin_import_path, alert: result.errors.join(", ")
      end
    end
  end
end
