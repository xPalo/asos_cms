class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!

  def index
    @posts = Post.is_public.includes(:user, :comments).search(params[:search])
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
    @post = Post.new(post_params)

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

  private

  def set_post
    @post = Post.includes(:user, :comments).find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :user_id, :downvotes, :upvotes, :is_public)
  end
end
