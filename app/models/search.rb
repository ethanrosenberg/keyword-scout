class Search < ApplicationRecord
  has_many :keywords
  after_create :start_job

  def start_job
    #Resque.enqueue(Runner::Scrape, self.id, self.keyword)
    build_searches

  end

  def stop_jobs
    if self.status != 'finished'
      Resque.queues.each {|queue| Resque.remove_queue(queue)}
      #Resque::Job.destroy(Runner::Scrape, self.id, self.keyword)
      self.update(status: 'stopped')
    end
  end

  def build_searches

    @queries = []
    alphabet = ('a'..'z').to_a
    first_results = Instant::Request.new(self.keyword).get

    first_results.each do |keyword|
       alphabet.each do |letter|
         queries << "#{keyword} #{letter}"
       end
    end

    queries.each {|kw| Resque.enqueue(Runner::Scrape, self.id, kw) }


  end



  def created_at
    self[:created_at].in_time_zone('Pacific Time (US & Canada)').strftime("%B %d, %Y %l:%M %p")
  end

  def updated_at
    self[:updated_at].in_time_zone('Pacific Time (US & Canada)').strftime("%B %d, %Y %l:%M %p")
  end

end
