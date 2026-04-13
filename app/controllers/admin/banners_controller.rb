module Admin
  class BannersController < BaseController
    before_action :set_banner, only: [ :edit, :update, :destroy, :toggle ]

    def index
      @banners = Banner.ordered
    end

    def new
      @banner = Banner.new(active: true, position: next_position)
    end

    def create
      @banner = Banner.new(banner_params)

      if @banner.save
        redirect_to admin_banners_path, notice: "Banner created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @banner.update(banner_params)
        redirect_to admin_banners_path, notice: "Banner updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @banner.destroy
      redirect_to admin_banners_path, notice: "Banner deleted."
    end

    def toggle
      @banner.update(active: !@banner.active?)
      redirect_to admin_banners_path, notice: "Banner #{@banner.active? ? 'enabled' : 'disabled'}."
    end

    def reorder
      Array(params[:ids]).each_with_index do |id, index|
        Banner.where(id: id).update_all(position: index)
      end
      head :ok
    end

    private

    def set_banner
      @banner = Banner.find(params[:id])
    end

    def next_position
      (Banner.maximum(:position) || -1) + 1
    end

    def banner_params
      params.require(:banner).permit(
        :title, :subtitle, :eyebrow, :link_url, :link_text,
        :position, :active, :starts_at, :ends_at, :image
      )
    end
  end
end
