Rails.application.routes.draw do
 
  
  resources :elastic_policies
  resources :elastic_reports
  resources :report_values
  resources :report_types
  root'dashboard#index'
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


end
