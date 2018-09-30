class CreateMemberships < ActiveRecord::Migration[5.2]
  def change
    create_table :memberships do |t|
      t.string :beer_club_id
      t.string :user_id

      t.timestamps
    end
  end
end
