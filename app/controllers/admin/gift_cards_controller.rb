module Admin
  class GiftCardsController < BaseController
    before_action :set_gift_card, only: [ :show, :edit, :update, :destroy ]

    def index
      @gift_cards = GiftCard.order(created_at: :desc).includes(:purchaser)
    end

    def show
      @transactions = @gift_card.gift_card_transactions.order(occurred_at: :desc)
    end

    def new
      @gift_card = GiftCard.new(initial_balance_cents: 5000, active: true)
    end

    def create
      @gift_card = GiftCard.new(gift_card_params)
      @gift_card.balance_cents = @gift_card.initial_balance_cents

      if @gift_card.save
        redirect_to admin_gift_card_path(@gift_card), notice: "Gift card issued: #{@gift_card.code}"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @gift_card.update(gift_card_params.except(:initial_balance_cents))
        redirect_to admin_gift_card_path(@gift_card), notice: "Gift card updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @gift_card.destroy
      redirect_to admin_gift_cards_path, notice: "Gift card deleted."
    end

    private

    def set_gift_card
      @gift_card = GiftCard.find(params[:id])
    end

    def gift_card_params
      params.require(:gift_card).permit(
        :initial_balance_cents, :balance_cents, :active, :expires_at,
        :recipient_email, :notes
      )
    end
  end
end
