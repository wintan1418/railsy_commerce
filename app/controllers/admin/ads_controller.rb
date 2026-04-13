module Admin
  class AdsController < BaseController
    before_action :set_ad, only: [ :edit, :update, :destroy, :toggle ]

    def index
      @ads = Ad.ordered.group_by(&:placement)
    end

    def new
      @ad = Ad.new(active: true, placement: "home_mid", position: next_position)
    end

    def create
      @ad = Ad.new(ad_params)
      if @ad.save
        redirect_to admin_ads_path, notice: "Ad created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @ad.update(ad_params)
        redirect_to admin_ads_path, notice: "Ad updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @ad.destroy
      redirect_to admin_ads_path, notice: "Ad deleted."
    end

    def toggle
      @ad.update(active: !@ad.active?)
      redirect_to admin_ads_path, notice: "Ad #{@ad.active? ? 'enabled' : 'disabled'}."
    end

    private

    def set_ad
      @ad = Ad.find(params[:id])
    end

    def next_position
      (Ad.maximum(:position) || -1) + 1
    end

    def ad_params
      params.require(:ad).permit(
        :title, :subtitle, :link_url, :placement, :position,
        :active, :starts_at, :ends_at, :image
      )
    end
  end
end
