Rails.application.routes.draw do
  resources :data_dump_dictionaries
  resources :data_dump_tables
root'dashboard#index'
  resources :table_entries
  resources :data_dictionaries
  resources :csv_uploads
  resources :master_tables
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post 'validate', to: 'csv_uploads#validate'
  post 'submit', to: 'csv_uploads#submit'
end
