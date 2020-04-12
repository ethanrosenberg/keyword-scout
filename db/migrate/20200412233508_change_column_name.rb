class ChangeColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :keywords, :type, :keyword_type
  end
end
