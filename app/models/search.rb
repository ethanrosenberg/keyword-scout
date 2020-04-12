class Search < ApplicationRecord
  has_many :keywords
  after_create :start_job

  def start_job
    Resque.enqueue(Runner::Scrape, self.id, self.keyword)
  end

  def stop_job
    if self.status != 'finished'
      Resque::Job.destroy(Runner::Scrape, self.id)
      self.update(status: 'finished')
    end
  end



  def created_at
    self[:created_at].in_time_zone('Pacific Time (US & Canada)').strftime("%B %d, %Y %l:%M %p")
  end

  def updated_at
    self[:updated_at].in_time_zone('Pacific Time (US & Canada)').strftime("%B %d, %Y %l:%M %p")
  end

end
