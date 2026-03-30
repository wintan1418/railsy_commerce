module Admin
  class PagesController < BaseController
    before_action :set_page, only: [ :show, :edit, :update, :destroy ]

    def index
      @pages = Page.ordered
    end

    def show
    end

    def new
      @page = Page.new
    end

    def create
      @page = Page.new(page_params)

      if @page.save
        redirect_to admin_page_path(@page), notice: "Page created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @page.update(page_params)
        redirect_to admin_page_path(@page), notice: "Page updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @page.destroy
      redirect_to admin_pages_path, notice: "Page deleted."
    end

    private

    def set_page
      @page = Page.friendly.find(params[:id])
    end

    def page_params
      params.require(:page).permit(:title, :slug, :body, :published, :position)
    end
  end
end
