class ApplicationController < ActionController::Base
  include AlphaHelper	
  before_action :get_e_index
  
  def get_e_index
  	@sources = Source.all
    begin
      @getter = get_elastic_index
      p 'getter success' 
      logger.debug("one two #{@getter}")
    rescue
      p 'getter fail'
    end 
  end


end 
