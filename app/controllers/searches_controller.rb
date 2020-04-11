class SearchesController < ApplicationController

  def search
      byebug
    #search = Search.create()
    base_keyword = "best glock"
    data_hash = Hash.new
    keywords = Crawler::Worker.new(base_keyword, 'a', data_hash).start
    write_output(data_hash)
    render json: { response_data: data_hash, keywords: keywords }

  end

end
