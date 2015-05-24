class AddMarkToCopies < ActiveRecord::Migration
  def change
    add_column :copies, :mark, :float
  end
end
