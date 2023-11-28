# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :set_message, only: [:show ,:destroy]
  before_action :set_receiver, only: [:show]
  before_action :set_sender, only: [:show]

  def index
    @sender_messages = Message.where(sender_id: current_user.id)
    @receiver_messages = Message.where(receiver_id: current_user.id)
  end

  def new
    @user = User.find(params[:user_id])
    @message = Message.new
  end

  def create
    @message = Message.new(message_params.merge(sender_id: current_user.id,receiver_id: params[:user_id]))

    respond_to do |format|
      if @message.save
        format.html { redirect_to user_chat_path(params[:user_id]), notice: t('message.created') }
        format.json { render :chat, status: :ok, location: @message }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def chat

    @message = Message.new
    # Retrieve messages for the current user or between specific users
    @messages = Message.where(sender_id: [current_user.id, params[:user_id]], receiver_id: [current_user.id, params[:user_id]])
                       .order(created_at: :asc)

    @user = User.find(params[:user_id])
  end

  def destroy
    @message.destroy

    redirect_to user_messages_path, notice: t('message.deleted')
  end

  private

  # sender_id a receiver_id nemoze byt nestaveny cez postman pretoze sa to nenachadza v permite
  def message_params
    params.require(:message).permit(:content, :subject)
  end

  def set_message
    @message = Message.find(params[:id])
  end

  def set_receiver
    @receiver = User.find(@message.receiver_id)
  end

  def set_sender
    @sender = User.find(@message.sender_id)
  end
end
