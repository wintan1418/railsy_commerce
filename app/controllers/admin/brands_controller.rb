module Admin
  class BrandsController < BaseController
    before_action :set_brand, only: [ :edit, :update, :destroy, :toggle_featured ]

    def index
      @brands = Brand.ordered
    end

    def new
      @brand = Brand.new(active: true, position: next_position)
    end

    def create
      @brand = Brand.new(brand_params)
      if @brand.save
        redirect_to admin_brands_path, notice: "Brand created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @brand.update(brand_params)
        redirect_to admin_brands_path, notice: "Brand updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @brand.destroy
      redirect_to admin_brands_path, notice: "Brand deleted."
    end

    def toggle_featured
      @brand.update(featured: !@brand.featured?)
      redirect_to admin_brands_path,
        notice: "Brand #{@brand.featured? ? 'featured' : 'unfeatured'}."
    end

    private

    def set_brand
      @brand = Brand.friendly.find(params[:id])
    end

    def next_position
      (Brand.maximum(:position) || -1) + 1
    end

    def brand_params
      params.require(:brand).permit(
        :name, :slug, :description, :website, :active, :featured, :position, :logo
      )
    end
  end
end
