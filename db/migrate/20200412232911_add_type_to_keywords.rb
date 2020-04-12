class AddTypeToKeywords < ActiveRecord::Migration[5.2]
  def change
    add_column :keywords, :type, :string
  end
end
