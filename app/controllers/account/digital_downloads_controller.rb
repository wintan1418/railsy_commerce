module Account
  class DigitalDownloadsController < BaseController
    before_action :set_download, only: [ :show ]

    def index
      @downloads = DigitalDownload
        .joins(order_item: :order)
        .where(orders: { user_id: Current.user.id })
        .includes(order_item: { variant: { product: { digital_files_attachments: :blob, images_attachments: :blob } } })
        .order(created_at: :desc)
    end

    def show
      return redirect_to account_digital_downloads_path, alert: "Download expired." if @download.expired?

      file = @download.files.find_by(id: params[:file_id]) || @download.files.first
      return redirect_to account_digital_downloads_path, alert: "No file available." unless file

      @download.record_download!
      redirect_to rails_blob_path(file, disposition: "attachment"), allow_other_host: false
    end

    private

    def set_download
      @download = DigitalDownload
        .joins(order_item: :order)
        .where(orders: { user_id: Current.user.id })
        .find_by!(id: params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to account_digital_downloads_path, alert: "Download not found."
    end
  end
end
