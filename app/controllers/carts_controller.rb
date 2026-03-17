class CartsController < ApplicationController
  include CartManagement
  allow_unauthenticated_access

  def show
  end
end
