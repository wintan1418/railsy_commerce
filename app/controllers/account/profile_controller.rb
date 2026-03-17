module Account
  class ProfileController < BaseController
    def show
    end

    def update
      if current_user.update(profile_params)
        redirect_to account_profile_path, notice: "Profile updated."
      else
        render :show, status: :unprocessable_entity
      end
    end

    private

    def profile_params
      params.require(:user).permit(:first_name, :last_name, :email_address)
    end
  end
end
