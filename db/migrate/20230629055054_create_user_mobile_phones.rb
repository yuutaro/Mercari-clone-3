class CreateUserMobilePhones < ActiveRecord::Migration[6.1]
  def change
    create_table :user_mobile_phones do |t|
      t.references :user, null: false, foreign_key: true
      t.string :number, nil: false, index: { unique: true }
      t.string :auth_code, nil: false, index: true

      t.timestamps
    end
  end
end
