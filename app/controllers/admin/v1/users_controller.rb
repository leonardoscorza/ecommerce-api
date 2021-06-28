module Admin::V1
  class UsersController < ApiController
    before_action :load_user, only: [:show, :update, :destroy]

    def index
      @users = load_users
    end

    def create
      @user = User.new
      @user.attributes = user_params
      save_user!
    end

    def show; end

    def update
      @user.attributes = user_params
      save_user!
    end

    def destroy
      @user.destroy!
    rescue
      render_error(fields: @user.errors.messages)
    end

    private

    def save_user!
      @user.save!
      render :show
    rescue
      render_error(fields: @user.errors.messages)
    end

    def load_user
      @user = User.find(params[:id])
    end

    def load_users
      permitted = params.permit({ search: :name }, { order: {} }, :page, :length)
      Admin::ModelLoadingService.new(User.all, permitted).call
    end

    def user_params
      return {} unless params.has_key?(:user)
      params.require(:user).permit(:id, :name, :email, :password, :password_confirmation, :profile)
    end

  end
end
