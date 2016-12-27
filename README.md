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

