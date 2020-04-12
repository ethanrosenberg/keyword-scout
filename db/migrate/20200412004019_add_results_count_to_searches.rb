class AddResultsCountToSearches < ActiveRecord::Migration[5.2]
  def change
    add_column :searches, :results_count, :integer
  end
end
