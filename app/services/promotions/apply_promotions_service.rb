module Promotions
  class ApplyPromotionsService < ApplicationService
    def initialize(order:)
      @order = order
    end

    def call
      promotions = Promotion.active_promotions.auto_apply.valid_now

      applicable = promotions.select { |promo| promo.applicable?(@order) }

      return success(applied: false) if applicable.empty?

      # Apply the best promotion (the one that provides the most benefit)
      best = applicable.first
      best.apply!(@order)

      success(applied: true, promotion: best)
    rescue => e
      failure(e.message)
    end
  end
end
