class Addvideotable < ActiveRecord::Migration
  def change
  	create_table :videos do |t|
  	 t.integer :stream_id
  	 t.string :stream_name
  	 t.string :email
  	 t.string :url
  	 t.string :source
  	end
  end
end
