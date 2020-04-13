ActiveAdmin.register Search do

  permit_params :keyword

  form do |f|
    f.inputs "Search" do
      f.input :keyword,  :as    => :string, :label => "Keyword", :hint => 'Enter keyword'
    end
    f.actions
  end


  action_item :view_site do
     link_to 'Workers', '/admin/resque_web'
  end

  member_action :stop, method: :get do

    Search.find(params[:id]).stop_jobs

    redirect_to '/admin/searches', notice: 'Scraping job was stopped.'
  end


  controller do
      def create

        @search = Search.new(status: 'working', keyword: params[:search][:keyword], results_count: 0)

        respond_to do |format|
          if @search.save
            format.html { redirect_to '/admin/searches', notice: 'Scraping job was started.' }
          else
            STDERR.puts @search.errors.to_yaml
            format.html { render action: "new" }
          end
        end
      end



  end

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :keyword
  #
  # or
  #
  # permit_params do
  #   permitted = [:keyword]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  member_action :smart, :method => :get do

      @items = Search.find(params[:id]).keywords[0..10]
      respond_to do |format|
        format.xlsx {
          response.headers['Content-Disposition'] = 'attachment; filename="report.xlsx"'
        }

        render xlsx: "temp", template: 'searches/temp'

      end
  end




  index do
    column "id", :id
    column "Run Time" do |job|
      if job.status != 'finished'
        distance_of_time_in_words_to_now(job.created_at)
      else
        distance_of_time_in_words(job.created_at, job.updated_at)
      end
    end
    column "Keyword", :keyword
    column "Results", :results_count
    column "Status", :status
    column "Stop Search" do |job|
      if job.status == 'finished' || job.status == 'stopped'
        'Done'
      else
        link_to "Stop", "/admin/searches/#{job.id}/stop/"
      end
    end
    column "Reports" do |job|
      if job.status == 'finished'
        link_to "Download Report", "/admin/searches/#{job.id}/smart.xlsx"
        #link_to 'Download as Excel', admin_searches_path(format: :xlsx)
      else
        "Waiting"
      end
    end

    column "Created At" do |search|
    #local_time()
      search.created_at
      #report.created_at.in_time_zone('Pacific Time (US & Canada)').strftime("%B %d, %Y %l:%M %p")
    end





    #column "Report Created", time.:created_at

  end




end
