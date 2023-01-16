class CreateJoinTableUserWaitlist < ActiveRecord::Migration[7.0]
  def change
    create_join_table :users, :waitlists do |t|
      # t.index [:user_id, :waitlist_id]
      # t.index [:waitlist_id, :user_id]
    end
  end
end
