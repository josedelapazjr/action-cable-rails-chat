class MessagesController < ApplicationController
  def index
    @messages = Message.all
    @message = Message.new
  end

  def create
    new_message = Message.new(message_params)
    if new_message.save
      render 'index'
    end
  end

  private
    def message_params
      params.require(:message).permit(:content)
    end
end
