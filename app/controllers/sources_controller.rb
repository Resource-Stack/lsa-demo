class SourcesController < ApplicationController
  before_action :set_source, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  include AlphaHelper

  # GET /sources or /sources.json
  def index
    @sources = Source.all
  end

  # GET /sources/1 or /sources/1.json
  def show
  end

  # GET /sources/new
  def new
    @source = Source.new
  end

  # GET /sources/1/edit
  def edit
  end

  # POST /sources or /sources.json
  def create
    
    mod_source = source_params
    mod_source['source_title'] = mod_source['source_title'].downcase    
    @source = Source.new(mod_source)

    respond_to do |format|
      if @source.save
        #create index
        `curl -X PUT "localhost:9200/#{mod_source['source_title']}?pretty"`

        format.html { redirect_to @source, notice: "Source was successfully created." }
        format.json { render :show, status: :created, location: @source }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @source.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sources/1 or /sources/1.json
  def update
    respond_to do |format|
      if @source.update(source_params)
        format.html { redirect_to @source, notice: "Source was successfully updated." }
        format.json { render :show, status: :ok, location: @source }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @source.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sources/1 or /sources/1.json
  def destroy
    #delete index as well
    `curl -X DELETE "localhost:9200/#{@source.source_title}?pretty"`
    
    @source.destroy
    respond_to do |format|
      format.html { redirect_to sources_url, notice: "Source was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_source
      @source = Source.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def source_params
      params.require(:source).permit(:source_title)
    end
end
