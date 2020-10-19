class CreatePayments < ActiveRecord::Migration[6.0]
    def change
        create_table :payments do |t|
            t.integer :payment_status, null: false, default: 0
            t.string :billplz_id
            t.string :x_signature
            t.text :details

            t.timestamps
        end
    end
end
