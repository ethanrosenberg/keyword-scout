class Search < ApplicationRecord
  has_many :keywords
  after_create :start_job
  after_commit :update_progress

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

    alphabet = ('a'..'z').to_a
    first_results = Instant::Request.new(self.keyword).get

  #  first_results.each {|first| self.keywords.create(keyword: first, status: 'done', keyword_type: 'query')}

    first_results[0..2].each do |keyword|
       alphabet.each do |letter|

         self.keywords.create(keyword: "#{keyword} #{letter}", status: 'ready', keyword_type: 'query')
       end
    end

  end

  def mark_finished
    self.update(status: 'finished')
  end

  def self.generate_report(id)
    results = Search.find(params[:id]).keywords[0..10]

    wb = xlsx_package.workbook
      wb.add_worksheet(name: "Buttons") do |sheet|
        results.each do |button|
          sheet.add_row [button.keyword]
        end
      end

      wb
    end



  def created_at
    self[:created_at].in_time_zone('Pacific Time (US & Canada)').strftime("%B %d, %Y %l:%M %p")
  end

  def updated_at
    self[:updated_at].in_time_zone('Pacific Time (US & Canada)').strftime("%B %d, %Y %l:%M %p")
  end

  def update_progress
    ActionCable.server.broadcast 'web_notifications_channel', id: self.id, results: self.keywords.count, status: self.status
  end

end
