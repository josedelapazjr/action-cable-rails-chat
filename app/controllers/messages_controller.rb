class MessagesController < ApplicationController
  def index
    @messages = Message.all
    @message = Message.new
  end

  def create
    new_message = Message.new(message_params)
    if new_message.save
      ActionCable.server.broadcast 'room_channel',
                                   name: new_message.name,
                                   content:  new_message.content
      head :ok
    end
  end

  def destroy_all
      Message.destroy_all
      head :ok
  end

  private
    def message_params
      params.require(:message).permit(:name, :content)
    end
end
