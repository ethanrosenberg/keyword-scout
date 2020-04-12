class Search < ApplicationRecord
  has_many :keywords
  after_create :start_job

  def start_job

    self.update(status: "working")
    Resque.enqueue(Runner::Scrape, self.id, self.keyword)





  end

  def created_at
    self[:created_at].in_time_zone('Pacific Time (US & Canada)').strftime("%B %d, %Y %l:%M %p")
  end

  def updated_at
    self[:updated_at].in_time_zone('Pacific Time (US & Canada)').strftime("%B %d, %Y %l:%M %p")
  end

end
