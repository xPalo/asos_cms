# frozen_string_literal: true

class MessagesController < ApplicationController
  # before_action :set_receiver, only: [:new, :create]

  def index
    @user = User.find(params[:user_id])
    @messages = @user.messages
  end

  def new
    @message = Message.new
  end

  def create
    puts "Received params: #{params.inspect}"

    @message = Message.new(message_params)
    puts @message
    puts message_params
    @message.save!
  end

  def destroy
    @message = current_user.messages.destroy(params[:id])
  end

  def show
    @message = current_user.messages.find(params[:id])
  end



  private

  def message_params
    params.require(:message).permit(:content, :receiver_id, :sender_id)
  end

  def set_receiver
    @receiver = User.find(params[:user_id])
  end
end
