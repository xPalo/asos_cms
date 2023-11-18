# frozen_string_literal: true

class MessangesController < ApplicationController
  before_action :set_receiver, only: [:new, :create]

  def new
    @message = Messange.new
  end

  def create
    @message = Messange.new()

    # @message = current_user.sent_messages.new message_params
    # @message.receiver_id = @receiver.id
    # @message.save
  end

  def index
    @messages = current_user.messages
  end

  def destroy
    @message = current_user.messages.destroy params[:id]
  end

  def show
    @message = current_user.messages.find params[:id]
  end

  private

  def message_params
    params.require(:message).permit(:content, :receiver_id, :sender_id,)
  end

  def set_receiver
    @receiver = User.find params[:user_id]
  end
end
