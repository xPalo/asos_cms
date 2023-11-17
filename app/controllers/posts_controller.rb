class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :new_comment, :create_comment]
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
end
