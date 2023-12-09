class HomeController < ApplicationController
  def index
  end

  def explore
    if params[:search_posts].present? || params[:order_posts].present? || params[:search_users] || params[:order_users]
      @can_reset = true
    end

    @posts = Post.includes(:user).search(params[:search_posts])
    if params[:order_posts].present?
      case params[:order_posts]
      when "title_asc"
        @posts = @posts.order("title ASC")
      when "title_desc"
        @posts = @posts.order("title DESC")

      when "content_asc"
        @posts = @posts.order("content ASC")
      when "content_desc"
        @posts = @posts.order("content DESC")

      when "votes_asc"
        @posts = @posts.sort_by { |b| b.votes_count }
      when "votes_desc"
        @posts = @posts.sort_by { |b| -b.votes_count }

      when "comments_count_asc"
        @posts = @posts.sort_by { |b| b.comments_count }
      when "comments_count_desc"
        @posts = @posts.sort_by { |b| -b.comments_count }

      else
        flash[:alert] = t('order.invalid_value')
      end
    end

    if @posts.class == Array
      @posts = Kaminari.paginate_array(@posts).page(params[:posts_page])
    else
      @posts = @posts.page(params[:posts_page])
    end

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

  def change_locale
    lang = params[:locale].to_s.strip.to_sym
    lang = I18n.default_locale unless I18n.available_locales.include?(lang)
    cookies[:lang] = lang
    redirect_to request.referer || root_url
  end
end
