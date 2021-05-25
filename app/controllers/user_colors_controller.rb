class UserColorsController < ApplicationController
  before_action :set_user_color, only: %i[ show edit update destroy ]
    before_action :set_header_values
  include ElasticSearchHelper

  # GET /user_colors or /user_colors.json
  def index
    @user_colors = UserColor.all
  end

  # GET /user_colors/1 or /user_colors/1.json
  def show
  end

  # GET /user_colors/new
  def new
    @user_color = UserColor.new
    @user_color.user_id = current_user.id if current_user
  end

  # GET /user_colors/1/edit
  def edit
  end

  # POST /user_colors or /user_colors.json
  def create
    @user_color = UserColor.new(user_color_params)

    respond_to do |format|
      if @user_color.save
        format.html { redirect_to @user_color, notice: "User color was successfully created." }
        format.json { render :show, status: :created, location: @user_color }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user_color.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_colors/1 or /user_colors/1.json
  def update
    respond_to do |format|
      if @user_color.update(user_color_params)
        format.html { redirect_to @user_color, notice: "User color was successfully updated." }
        format.json { render :show, status: :ok, location: @user_color }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user_color.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_colors/1 or /user_colors/1.json
  def destroy
    @user_color.destroy
    respond_to do |format|
      format.html { redirect_to user_colors_url, notice: "User color was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_header_values 
      begin
        @all_data = fetch_all
        p 'success'
      rescue
        p 'issue'
      end 

      @headerValues = []
      check = JSON.parse(@all_data[0])
      check.each do |kilo,alpha|
        @headerValues.push(kilo)
      end  
    end 
    # Use callbacks to share common setup or constraints between actions.
    def set_user_color
      @user_color = UserColor.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_color_params
      params.require(:user_color).permit(:color, :user_id)
    end
end
