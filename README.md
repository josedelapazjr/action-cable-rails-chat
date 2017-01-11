# Sample Chat (using Rails ActionCable)

1. Create the rails project:

		> rails new sampleChat -d postgresql

2. Create migration:

		> rails g migration CreateMessages

3. Update migration file:

		class CreateMessages < ActiveRecord::Migration[5.0]
		  def change
		    create_table :messages do |t|
		      t.text :content
		      t.timestamps
		    end
		  end
		end

4. Create the table:

		> rails db:migrate	

5. Create the message model app/nodels/message.rb

		class Message < ApplicationRecord
		end
		
6. Create message controller app/controllers/messages_controller.rb

		class MessagesController < ApplicationController
		  def index
		    @messages = Message.all
		    @message = Message.new
		  end
		
		  def create
		    new_message = Message.new(message_params)
		    if new_message.save
		    	@messages = Message.all
     			 @message = Message.new
		      render 'index'
		    end
		  end
		
		  private
		    def message_params
		      params.require(:message).permit(:content)
		    end
		end


7. Create view app/views/messages/index.html

		<h1>Messages</h1>
		<ul>
		  <% @messages.each do |message| %>
		    <li><%= message.content %></li>
		  <% end %>
		</ul>
		
		<%= form_for(@message, remote: true) do |f| %>
		  <%= f.text_area :content %>
		  <%= f.submit "Send" %>
		<% end %>

		
8. Modify routes config/routes.rb

		Rails.application.routes.draw do
		  root 'messages#index'
		  resources :messages
		end

		

Action Cable

1. Generate action cable channels:

		> rails generate channel Room
			   create  app/channels/room_channel.rb
		   identical  app/assets/javascripts/cable.js
		      create  app/assets/javascripts/channels/room.coffee
		      
2. Reset database

		> rails db:migrate:reset
		
3. Inialize channel app/channels/room_channel.rb:

		class RoomChannel < ApplicationCable::Channel
		  def subscribed
		    stream_from "room_channel"
		  end
		
		  def unsubscribed
		    # Any cleanup needed when channel is unsubscribed
		  end
		end
		
4. Modify the message controller to broadcast data after creating message:
	
		if new_message.save
	      ActionCable.server.broadcast 'room_channel',
	                                   content:  new_message.content
	      head :ok
	    end
	    
5. Handle received message app/assets/javascripts/channels/room.coffee:

		App.room = App.cable.subscriptions.create "RoomChannel",
		  connected: ->
		    # Called when the subscription is ready for use on the server
		
		  disconnected: ->
		    # Called when the subscription has been terminated by the server
		
		  received: (data) ->
		    #alert data.content
		    $('#messageList ul').append '<li>' + data.content + '</li>'
		    
6. Mount a action cable server in routes:

		mount ActionCable.server, at: '/cable'

7. Modify the config/environments/development.rb file and add the expected client addresses in the following line:

		Rails.application.config.action_cable.allowed_request_origins = ['http://localhost:3001','http://localhost:3002']
		

Note: If you encounter the following error:

	ActionCable NoMethoError - undeined method 'fetch' for nil:NilClass
	
just add the config/cable.yml file:

	development:
	  adapter: async
	
	test:
	  adapter: async
	
	production:
	  adapter: redis
	  url: redis://localhost:6379/1

