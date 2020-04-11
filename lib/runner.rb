module Runner
  class Scrape

    @queue = :keywords_queue

    def initialize(id, base)
      @base = base
      @search = Search.find(id)
      @alphabet = ('a'..'z').to_a
      @rough_time = 0

    end

    def self.perform(id, base)
      Runner::Scrape.new(id, base).start
    end

    def start

      search_first_level

      search_second_level


      @search.update(status: "finished")
    end

    def search_first_level

      @first_results = Instant::Request.new(@base).get
      process_results(@first_results)

    end

    def search_second_level

      #@rough_time = (@search.keywords.count * 26) * 5

      #first_keywords = @search.keywords

       @first_results.each do |keyword|

          #search each keyword + 'a', 'b', etc...
          @alphabet.each do |letter|



          #search keyword + 'a' or whatever letter
            results = Instant::Request.new("#{keyword} #{letter}").get
            process_results(results)

            sleep = rand(0.2..0.5)
            sleep sleep
          end
        end

    end



    def process_results(results)
        results.each do |res|
          if !keyword_already_exists?(res)
            @search.keywords.create(keyword: res)
          end
        end
    end

    def keyword_already_exists?(kw)
      @search.keywords.where(:keyword => kw).blank? ? false : true
    end



  end
end
