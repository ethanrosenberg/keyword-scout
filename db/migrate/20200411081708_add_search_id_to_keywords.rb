class AddSearchIdToKeywords < ActiveRecord::Migration[5.2]
  def change
    add_reference :keywords, :search, foreign_key: true
  end
end
