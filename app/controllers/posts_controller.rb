class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :new_comment, :create_comment, :create_vote]
  before_action :authenticate_user!
  before_action :can_manipulate?, only: [:edit, :update, :destroy, :create, :new]

  def index
    @posts = Post.is_public.includes(:user, :comments).search(params[:search_posts])

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
        @posts = @posts.sort_by { |b| -b.votes_count }
      when "votes_desc"
        @posts = @posts.sort_by { |b| b.votes_count }

      when "comments_count_asc"
        @posts = @posts.sort_by { |b| -b.comments_count }
      when "comments_count_desc"
        @posts = @posts.sort_by { |b| b.comments_count }

      else
        flash[:alert] = t('order.invalid_value')
      end
    end

    if @posts.class == Array
      @posts = Kaminari.paginate_array(@posts).page(params[:page])
    else
      @posts = @posts.page(params[:page])
    end
  end

  def show
    @comments = @post.comments.order(:created_at)
  end

  def new
    @post = Post.new(is_public: true)
  end

  def create
    @post = Post.new(post_params.merge(user_id: current_user.id))

    respond_to do |format|
      if @post.save
        format.html { redirect_to post_path(@post), notice: t('post.created') }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_path(@post), notice: t('post.updated') }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_path, notice: t('post.deleted') }
      format.json { head :no_content }
    end
  end

  def new_comment
    @comment = Comment.new
  end

  def create_comment
    @comment = Comment.new(comment_params.merge(user_id: current_user.id, post_id: @post.id))

    respond_to do |format|
      if @comment.save
        format.html { redirect_to post_path(@post), notice: t('activerecord.attributes.comment.added') }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new_comment, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_vote
    return if current_user&.id == @post&.user_id

    @vote = Vote.find_or_initialize_by(user_id: current_user.id, post_id: @post.id)

    @vote.assign_attributes(vote_params)

    respond_to do |format|
      if @vote.save && current_user&.id != @post&.user_id
        format.html { redirect_to post_path(@post), notice: t('activerecord.attributes.vote.added') }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :show, status: :unprocessable_entity }
        format.json { render json: @vote.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_post
    @post = Post.includes(:user, :comments).find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :is_public)
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def vote_params
    params.require(:vote).permit(:vote_type)
  end

  def can_manipulate?
    return if @post.user_id == current_user&.id

    redirect_back(
      fallback_location: posts_path,
      flash: { alert: t('not_authorized') }
    )
  end
end
