class UsersController < ApplicationController

  def show
  	@user = current_user
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

  private
    def user_params
      params.require(:user).permit( :role_id, :overlooking_user, :user_first_name, :user_last_name)
    end

end
