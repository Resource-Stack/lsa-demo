Rails.application.routes.draw do
  resources :sources
  resources :user_colors
  resources :chart_preferences
  root'table_entries#index'
  
  resources :elastic_policies
  resources :elastic_reports
  resources :report_values
  resources :report_types
  resources :roles
  devise_for :users
  resources :users, only: [:index, :show, :edit, :update]
  resources :data_dump_dictionaries
  resources :data_dump_tables
  resources :table_entries
  resources :data_dictionaries
  resources :csv_uploads
  resources :master_tables
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'validate', to: 'csv_uploads#validate'
  post 'submit', to: 'csv_uploads#submit'
  get 'add_data_dictionary', to: 'csv_uploads#add_data_dictionary'
  get 'add_data_dump', to: 'csv_uploads#add_data_dump'
  #Reports
  post 'timeRangeReport', to: 'dashboard#timeRangeReport'
  post 'restrictParam', to: 'dashboard#restrictParam'
  post 'findBy', to: 'dashboard#findBy'
  #update Field Selections
  post 'update_time_field_selection', to: 'dashboard#updateTimeFieldSelection'
  post 'update_filter_one', to: 'dashboard#update_filter_one'
  post 'update_filter_two', to: 'dashboard#update_filter_two'
  post 'find_by_filter', to: 'dashboard#find_by_filter'
  #
  post 'upload_user_data', to: 'users#upload_user_data'
  #elastic policy
  post 'update_output', to: 'elastic_policies#update_output' 
  post 'update_input', to: 'elastic_policies#update_input' 
  post 'create_policy', to: 'elastic_policies#create_policy'

  #dummy route
  post 'false_create', to: 'elastic_policies#false_create'
  #
  get 'dashboard', to: 'dashboard#index'

  #master table testing area
  post 'update_query_output', to: 'master_tables#update_input' 
  post 'query_module', to: 'master_tables#query_module'

  #hide a chart
  post 'hide_chart', to: 'dashboard#hide_chart'
  post 'hide_search_chart', to: 'master_tables#hide_search_chart'

  #toggle a chart
  post 'toggle_chart', to: 'users#toggle_chart'


end
