module Admin::V1
  class CouponsController < ApiController
    before_action :load_coupon, only: [:show, :update, :destroy]

    def index
      @coupons = load_coupons
    end

    def create
      @coupon = Coupon.new
      @coupon.attributes = coupon_params
      save_coupon!
    end

    def show; end

    def update
      @coupon.attributes = coupon_params
      save_coupon!
    end

    def destroy
      @coupon.destroy!
    rescue
      render_error(fields: @coupon.errors.messages)
    end

    private

    def save_coupon!
      @coupon.save!
      render :show
    rescue
      render_error(fields: @coupon.errors.messages)
    end

    def load_coupon
      @coupon = Coupon.find(params[:id])
    end

    def load_coupons
      permitted = params.permit({ search: :name }, { order: {} }, :page, :length)
      Admin::ModelLoadingService.new(Coupon.all, permitted).call
    end

    def coupon_params
      return {} unless params.has_key?(:coupon)
      params.require(:coupon).permit(:id, :name, :code, :status, :discount_value, :max_use, :due_date)
    end

  end
end