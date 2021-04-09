class UsersController < ApplicationController

  def index
    @users = User.all
  end 

  def show
    p 'hey'
    @selected_user = User.find_by(id: params[:id])
    p @selected_user

        if @selected_user.table_entries.present?
          @masterTable = @selected_user.master_table
          @masterRow = []
          p @masterTable
          @masterTable.attributes.each do |k,v|
            if k != 'id' && k != 'created_at' && k != 'updated_at' && v != nil
              @masterRow.push(v)
            end 
          end
        end 
  	#@selected_user = current_user
  	p current_user.inspect
  end

  def edit
  	@user = current_user
    @roles = Role.all 

  end 

  def update 
    respond_to do |format|
      if current_user.update(user_params)
        format.html { redirect_to user_path(current_user.id), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end 


  def upload_user_data 

    # need to add a check if it can be uploaded .

    sender =  User.find(params[:user])
    p sender.inspect
    csv_id = CsvUpload.find(params[:id])
    p 'csv'
    p csv_id.inspect
    p csv_id.csv_file

    reciever = current_user
    #create a new csv_upload
      admin_copy_csv = CsvUpload.new
      admin_copy_csv.user_id = current_user.id
      admin_copy_csv.source_id = csv_id.source_id
      admin_copy_csv.policy_id = csv_id.policy_id
      admin_copy_csv.forescout_id = csv_id.forescout_id
      admin_copy_csv.csv_file = nil #copy.csv_file.attach(original.csv_id.csv_file.blob)
      admin_copy_csv.uploaded_to_superior = true
      admin_copy_csv.uploaded_from = csv_id.id
      admin_copy_csv.uploaded = false
    
      respond_to do |format|
        if admin_copy_csv.save 
          format.html { redirect_to admin_copy_csv, notice: "Csv upload was successfully created." }
          format.json { render :show, status: :created, location: admin_copy_csv }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: admin_copy_csv.errors, status: :unprocessable_entity }
        end 
      end 


  end 

  private
    def user_params
      params.require(:user).permit( :role_id, :overlooking_user, :user_first_name, :user_last_name)
    end

end
