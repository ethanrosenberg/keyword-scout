class AddStatusToKeywords < ActiveRecord::Migration[5.2]
  def change
    add_column :keywords, :status, :string
  end
end
