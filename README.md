# README
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



Action Cable

1. Generate action cable channels:

		> rails generate channel Room
			   create  app/channels/room_channel.rb
		   identical  app/assets/javascripts/cable.js
		      create  app/assets/javascripts/channels/room.coffee
		      
2. Reset database

		> rails db:migrate:reset
		
3. Inialize channel:

		class RoomChannel < ApplicationCable::Channel
		  def subscribed
		    stream_from "room_channel"
		  end
		
		  ...
		end
		
4. Modify the message controller to broadcast data after creating message:
	
		if new_message.save
	      ActionCable.server.broadcast 'room_channel',
	                                   content:  new_message.content
	      head :ok
	    end
	    
5. Handle received message:

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
