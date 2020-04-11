ActiveAdmin.register Search do



  permit_params :keyword

  form do |f|
    f.inputs "Search" do
      f.input :keyword,  :as    => :string, :label => "Keyword", :hint => 'Enter keyword'
    end
    f.actions
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
    column "Keyword", :keyword
    column "Status", :status
    column "Created At" do |search|
    #local_time()
      search.created_at
      #report.created_at.in_time_zone('Pacific Time (US & Canada)').strftime("%B %d, %Y %l:%M %p")
    end
    #column "Report Created", time.:created_at

  end

end
