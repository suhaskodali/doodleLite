class CreateOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :options do |t|
      t.integer :poll_id
      t.string :name
      t.integer :numVotes

      t.timestamps
    end
  end
end
