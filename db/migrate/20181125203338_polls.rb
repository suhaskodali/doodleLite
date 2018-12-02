class Polls < ActiveRecord::Migration[5.2]
  def change
    add_column :polls, :totalVotes, :integer
  end
end
