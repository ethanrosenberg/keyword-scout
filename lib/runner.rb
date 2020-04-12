module Runner

  class Scrape

    @queue = :keywords

    def initialize(id, base)
      @base = base
      @search = Search.find(id)

    end

    def self.perform(id, base)
      Runner::Scrape.new(id, base).start
    end

    def start

      unless @search.status == 'stopped' || @search.status == 'finished'

        search_keyword

        @search.update(results_count: @search.keywords.count)
        update_progress

      end

    end


    def search_keyword
      results = Instant::Request.new("#{keyword} #{letter}").get
      process_results(results)

      sleep = rand(0.2..0.5)
      sleep sleep
    end



    def process_results(results)
        results.each do |res|
          if !keyword_already_exists?(res)
            @search.keywords.create(keyword: res)
          end
        end
        @search.update(results_count: @search.keywords.count)
        update_progress
    end

    def keyword_already_exists?(kw)
      @search.keywords.where(:keyword => kw).blank? ? false : true
    end

    def update_progress
      ActionCable.server.broadcast 'web_notifications_channel', id: @search.id, results: @search.keywords.count, status: @search.status
    end



  end
end
