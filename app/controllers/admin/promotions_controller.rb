module Admin
  class PromotionsController < BaseController
    before_action :set_promotion, only: %i[edit update destroy]

    def index
      @promotions = Promotion.order(created_at: :desc)
    end

    def new
      @promotion = Promotion.new
    end

    def create
      @promotion = Promotion.new(promotion_params)
      if @promotion.save
        redirect_to admin_promotions_path, notice: "Promotion created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @promotion.update(promotion_params)
        redirect_to admin_promotions_path, notice: "Promotion updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @promotion.destroy
      redirect_to admin_promotions_path, notice: "Promotion deleted."
    end

    private

    def set_promotion
      @promotion = Promotion.find(params[:id])
    end

    def promotion_params
      permitted = params.require(:promotion).permit(:name, :promotion_type, :active, :auto_apply, :starts_at, :expires_at, :conditions)
      if permitted[:conditions].is_a?(String) && permitted[:conditions].present?
        permitted[:conditions] = JSON.parse(permitted[:conditions])
      end
      permitted
    rescue JSON::ParserError
      permitted
    end
  end
end
