class CreateImages < ActiveRecord::Migration[6.1]
  def change
    create_table :images do |t|
      t.string :avatar
      t.string :title
      t.integer :status
      t.string :result
      t.string :pos_xp1
      t.string :pos_yp1
      t.string :pos_xl1
      t.string :pos_yl1
      t.string :pos_xp2
      t.string :pos_yp2
      t.string :pos_xl2
      t.string :pos_yl2
      t.timestamps
    end
  end
end
