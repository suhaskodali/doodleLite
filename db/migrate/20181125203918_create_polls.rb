class CreatePolls < ActiveRecord::Migration[5.2]
  def change
    create_table :polls do |t|
      t.text :title
      t.text :description
      t.integer :user_id
      t.integer :totalVotes

      t.timestamps
    end
  end
end
