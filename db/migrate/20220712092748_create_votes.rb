class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.integer :value, null: false
      t.belongs_to :user, foreign_key: true
      t.belongs_to :voteable, polymorphic: true

      t.timestamps
    end
  end
end
