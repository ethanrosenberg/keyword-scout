class Keyword < ApplicationRecord
  after_create :start_job
  after_commit :check_for_finish
  belongs_to :search
  #after_create :process_children

  #def process_children
    #trimmed_keyword =
    #words = self.base.split(/[^[[:word:]]]+/)
  #end

  def start_job

    Resque.enqueue(Runner::Scrape, self.search.id, self.id, self.keyword) if self.keyword_type != 'result'
      #queries.each {|kw| Resque.enqueue(Runner::Scrape, self.id, kw) }
  end

  def check_for_finish
    if Keyword.where("search_id = ? AND status = ?", self.search.id, 'ready').count == 0
      self.search.mark_finished
    end
  end

  def created_at
    self[:created_at].in_time_zone('Pacific Time (US & Canada)').strftime("%B %d, %Y %l:%M %p")
  end

  def updated_at
    self[:updated_at].in_time_zone('Pacific Time (US & Canada)').strftime("%B %d, %Y %l:%M %p")
  end

end
