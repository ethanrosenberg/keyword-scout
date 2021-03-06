module Runner

  class Scrape

    @queue = :keywords

    def initialize(id, keyword_id, base)
      @base = base
      @search = Search.find(id)
      @keyword = Keyword.find(keyword_id)

    end

    def self.perform(id, keyword_id, base)
      Runner::Scrape.new(id, keyword_id, base).start
    end

    def start

      unless @search.status == 'stopped' || @search.status == 'finished'

        search_keyword

      end

    end


    def search_keyword
      results = Instant::Request.new(@base).get
      process_results(results)

      @search.update(results_count: @search.keywords.count)
      @keyword.update(status: "done")

      sleep = rand(0.2..0.5)
      sleep sleep
    end



    def process_results(results)
        results.each do |res|
          if !keyword_already_exists?(res)
            @search.keywords.create(keyword: res, keyword_type: 'result')
          end
        end

    end

    def keyword_already_exists?(kw)
      @search.keywords.where(:keyword => kw).blank? ? false : true
    end




  end
end
