module Account
  class AddressesController < BaseController
    before_action :set_address, only: %i[edit update destroy]

    def index
      @addresses = current_user.addresses
    end

    def new
      @address = current_user.addresses.build
    end

    def create
      @address = current_user.addresses.build(address_params)
      if @address.save
        redirect_to account_addresses_path, notice: "Address added."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @address.update(address_params)
        redirect_to account_addresses_path, notice: "Address updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @address.destroy
      redirect_to account_addresses_path, notice: "Address removed."
    end

    private

    def set_address
      @address = current_user.addresses.find(params[:id])
    end

    def address_params
      params.require(:address).permit(:first_name, :last_name, :address_line_1, :address_line_2, :city, :state, :postal_code, :country_code, :phone)
    end
  end
end
