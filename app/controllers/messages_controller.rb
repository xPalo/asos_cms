# frozen_string_literal: true

class MessagesController < ApplicationController
  # before_action :set_receiver, only: [:new, :create]

  def index
    # Retrieve messages for the current user or between specific users
    @messages = Message.where(sender_id: [current_user.id, params[:user_id]], receiver_id: [current_user.id, params[:user_id]])
                       .order(created_at: :asc)
    # Ensure @messages is not nil
    @messages ||= []

    @friend = User.find(params[:user_id])
    @me = User.find(current_user.id)

  end

  def new
    @user_id = User.find(params[:user_id])
    @message = Message.new
  end

  def create
    @message = Message.new(message_params.merge(sender_id: current_user.id,receiver_id: params[:user_id]))

    respond_to do |format|
      if @message.save
        format.html { redirect_to user_messages_path(current_user.id), notice: t('post.created') }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end



  end

  def destroy
    @message = current_user.messages.destroy(params[:id])
  end

  def show
  end



  private

  def message_params
    params.require(:message).permit(:content, :subject)
  end

  def receiver
    User.find(@message.receiver_id)
  end

  def set_receiver
    @receiver = User.find(params[:user_id])
  end
end
