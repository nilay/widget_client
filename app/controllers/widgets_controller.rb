class WidgetsController < ApplicationController
  before_action :authenticate_user

	def new
    @widget = Widget.new
  end

  # POST /widgets
  # POST /widgets.json
  def create
    @widget = Widget.new(widget_params)
    respond_to do |format|
      response = @widget.save(current_user)
      if response
        format.html { redirect_to root_path, notice: "Widget created successfully" }
      else
        format.html { render :new }
      end
    end
  end

  def update
    @widget = Widget.new(widget_params)
    @widget.id = params[:id]
    respond_to do |format|
      response = @widget.save(current_user)
      if response
        format.html { redirect_to request.referer, notice: "Widget updated successfully" }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    response = Widget.destroy(current_user, params[:id])
    redirect_to request.referer
  end

  private

  def widget_params
  	params.require(:widget).permit(:description, :name, :id, :kind)
  end
end
