class Search < ApplicationRecord
  has_many :keywords
  after_create :start_job

  def start_job


    Runner::Scrape.new(self.id, self.keyword).start

    byebug



  end
end
