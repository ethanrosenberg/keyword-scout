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

    column "Created At" do |search|
    #local_time()
      search.created_at
      #report.created_at.in_time_zone('Pacific Time (US & Canada)').strftime("%B %d, %Y %l:%M %p")
    end
    #column "Report Created", time.:created_at

  end

end
