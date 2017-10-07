class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :firstName
      t.string :lastName
      t.string :userName
      t.string :password
      t.integer :gender
      t.date :dateBirth
      t.integer :mobilePhone
      t.string :currentEmail
      t.integer :location

      t.timestamps
    end
  end
end
