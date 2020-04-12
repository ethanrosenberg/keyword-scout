module Test



  class Job

    @queue = :jobs
    
    def initialize(message)
      @message = message
    end
    def self.perform(message)
      Test::Job.new(message).start
    end

    def start
      puts "Its working!"

    end

  end

end
