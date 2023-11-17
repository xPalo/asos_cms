class CommentsController < ApplicationController
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :can_manipulate?, only: [:edit, :update, :destroy]

  def edit
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to post_path(@comment.post), notice: t('activerecord.attributes.comment.updated') }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    post = @comment.post
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to post_path(post), notice: t('comment.deleted') }
      format.json { head :no_content }
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def can_manipulate?
    return if @comment.user_id == current_user&.id

    redirect_back(
      fallback_location: posts_path,
      flash: { alert: t('not_authorized') }
    )
  end
end
