class MessagesController < ApplicationController
  before_action :set_message, only: [:show ,:destroy]
  before_action :can_manipulate?, only: [:show ,:destroy]

  def index
    @sent_messages = Message.where(sender_id: current_user.id)
    @received_messages = Message.where(receiver_id: current_user.id)
  end

  def new
    @user = User.find(params[:user_id])
    @message = Message.new(sender_id: current_user.id, receiver_id: params[:user_id])
  end

  def create
    @user = User.find(params[:user_id])
    @message = Message.new(message_params.merge(sender_id: current_user.id, receiver_id: params[:user_id]))

    respond_to do |format|
      if @message.save
        format.html { redirect_to user_chat_path(@user), notice: t('message.created') }
        format.json { render :chat, status: :ok, location: @user }
      else
        format.html { render :new, user_id: @user.id, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def chat
    @message = Message.new
    @messages = Message.where(sender_id: [current_user.id, params[:user_id]], receiver_id: [current_user.id, params[:user_id]])
                       .order(created_at: :asc)

    @user = User.find(params[:user_id])
  end

  def destroy
    @message.destroy

    respond_to do |format|
      format.html { redirect_to user_messages_path, notice: t('message.deleted') }
      format.json { head :no_content }
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :subject)
  end

  def set_message
    @message = Message.find(params[:id])
    @receiver = User.find(@message.receiver_id)
    @sender = User.find(@message.sender_id)
  end

  def can_manipulate?
    return if @message.receiver_id == current_user&.id || @message.sender_id == current_user&.id

    redirect_back(
      fallback_location: user_messages_path,
      flash: { alert: t('not_authorized') }
    )
  end
end
