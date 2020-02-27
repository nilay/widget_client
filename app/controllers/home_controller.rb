class HomeController < ApplicationController
  def index
  	search_query = params[:val] || ''
  	@widgets = Widget.all("visible",search_query, current_user)
  end
end
