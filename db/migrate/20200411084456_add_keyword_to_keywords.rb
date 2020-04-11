class AddKeywordToKeywords < ActiveRecord::Migration[5.2]
  def change
    add_column :keywords, :keyword, :string
  end
end
