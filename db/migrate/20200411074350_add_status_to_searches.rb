class AddStatusToSearches < ActiveRecord::Migration[5.2]
  def change
    add_column :searches, :status, :string
  end
end
