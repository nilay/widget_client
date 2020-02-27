class UsersController < ApplicationController
  before_action :authenticate_user, except: [:create]
  before_action :set_user, only: [:show, :edit, :update, :destroy, :widgets]
  before_action :check_user_is_logged_in, only: [:create, :new]

  def index
    @users = User.all(current_user)
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  def me
    response = User.me(current_user)
    @user = User.new(response[:data][:user])
    search_query = params[:val] || ''
    @widgets = Widget.all_by_user(@user.id,search_query, current_user)
    session[:user_information] = extract_user_information(response[:data])
    render "widgets"
  end

  def widgets
    search_query = params[:val] || ''
    @widgets = Widget.all_by_user(params[:id],search_query, current_user)
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      response = @user.save
      if response && response[:data] && response[:data][:user] && response[:data][:user][:id]
        session[:user_information] = extract_user_information(response[:data])
        format.html { redirect_to root_path }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def reset_password
    @user = User.new
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      response = User.find(params[:id], current_user)
      @user = User.new(response[:data][:user])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :first_name, :last_name, :date_of_birth, :image, :password, :password_confirmation, :image_url)
    end
end
