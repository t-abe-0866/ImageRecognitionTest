class AddToImages < ActiveRecord::Migration[6.1]
  def change
    add_column :images, :suggestion, :string
  end
end
