class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

    has_one :master_table
    has_many :table_entries
	has_many :data_dictionaries
	has_many :csv_uploads
	has_many :user_colors
end
