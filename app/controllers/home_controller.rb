class HomeController < ApplicationController
  def index
  end

  def explore
    if (params[:search] && (params[:search].length > 0)) || (params[:order] && (params[:order].length > 0))
      @can_reset = true
    end

    @posts = Post.includes(:user).search(params[:search])
    if params[:order] && (params[:order].length > 0)
      case params[:order]
      when "title_asc"
        @posts = @posts.order("title ASC")
      when "title_desc"
        @posts = @posts.order("title DESC")

      when "content_asc"
        @posts = @posts.order("content ASC")
      when "content_desc"
        @posts = @posts.order("content DESC")

      when "votes_asc"
        @posts = @posts.sort_by { |b| -b.comments_count }
      when "votes_desc"
        @posts = @posts.sort_by { |b| b.comments_count }

      when "comments_count_asc"
        @posts = @posts.sort_by { |b| -b.votes }
      when "comments_count_desc"
        @posts = @posts.sort_by { |b| b.votes }

      else
        flash[:alert] = t('order.invalid_value')
      end
    end

    if @posts.class == Array
      @posts = Kaminari.paginate_array(@posts).page(params[:posts_page])
    else
      @posts = @posts.page(params[:posts_page])
    end

    @users = User.where.not(id: current_user&.id).page(params[:users_page])
  end

  def change_locale
    lang = params[:locale].to_s.strip.to_sym
    lang = I18n.default_locale unless I18n.available_locales.include?(lang)
    cookies[:lang] = lang
    redirect_to request.referer || root_url
  end
end
