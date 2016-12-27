class MessagesController < ApplicationController
  def index
    @messages = Message.all
    @message = Message.new
  end

  def create
    new_message = Message.new(message_params)
    if new_message.save
      ActionCable.server.broadcast 'room_channel',
                                   content:  new_message.content
      head :ok
    end
  end

  private
    def message_params
      params.require(:message).permit(:content)
    end
end
