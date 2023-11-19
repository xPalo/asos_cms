class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :authenticate_user!

  def index
    @users = User.search(params[:search_users], current_user)

    if params[:order_users].present?
      case params[:order_users]
      when "first_name_asc"
        @users = @users.order("first_name ASC")
      when "first_name_desc"
        @users = @users.order("first_name DESC")

      when "last_name_asc"
        @users = @users.order("last_name ASC")
      when "last_name_desc"
        @users = @users.order("last_name DESC")

      when "email_asc"
        @users = @users.order("email ASC")
      when "email_desc"
        @users = @users.order("email DESC")

      else
        flash[:alert] = t('order.invalid_value')
      end
    end

    if @users.class == Array
      @users = Kaminari.paginate_array(@users).page(params[:users_page])
    else
      @users = @users.page(params[:users_page])
    end
  end

  def show
    @user_posts = Post.where(user_id: @user.id)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
