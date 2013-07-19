#require 'rubygems'
#require 'rbconfig'
#require 'mechanize'
#require 'open-uri'


class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_action :create_new_user_if_not_exist, only: [:new, :create]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
    @user.search_ldap(session[:cas_user])
    @user.get_user if @user.first_name.nil?
  end

  # GET /users/1/edit
  def edit
    @id = params[:id]
    if @id.nil?
      @user = User.find(@current_user.id)
    else
      @user = User.find(@id)
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.netid = session[:cas_user]

    respond_to do |format|
      if @user.save
        format.html { redirect_to "/auth/facebook" }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)  
        format.html { redirect_to "/auth/facebook" }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    #delete their schedule and matches eventually
  
    respond_to do |format|
      format.html { redirect_to logout_path  }
      format.json { head :no_content }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
     def set_user
      if params[:id] == nil
        @user = @current_user
      else
        @user = User.find(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name,:first_name, :last_name, :netid, :class_year, :res_college, :email, :phone, :gender, :facebook_id, :friends)
    end
end
