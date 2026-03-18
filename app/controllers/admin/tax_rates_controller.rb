module Admin
  class TaxRatesController < BaseController
    before_action :set_tax_rate, only: %i[edit update destroy]

    def index
      @tax_rates = TaxRate.order(:country_code, :state)
    end

    def new
      @tax_rate = TaxRate.new
    end

    def create
      @tax_rate = TaxRate.new(tax_rate_params)
      if @tax_rate.save
        redirect_to admin_tax_rates_path, notice: "Tax rate created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @tax_rate.update(tax_rate_params)
        redirect_to admin_tax_rates_path, notice: "Tax rate updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @tax_rate.destroy
      redirect_to admin_tax_rates_path, notice: "Tax rate deleted."
    end

    private

    def set_tax_rate
      @tax_rate = TaxRate.find(params[:id])
    end

    def tax_rate_params
      params.require(:tax_rate).permit(:name, :rate, :country_code, :state, :active)
    end
  end
end
