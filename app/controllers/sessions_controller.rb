class SessionsController < ApplicationController
	skip_before_action RubyCAS::Filter, only: [:new]
	skip_before_action :update_existing_user
  	skip_before_action :create_new_user_if_not_exist
	skip_before_action :current_user, only: [:logout]

	def new
	end

	def login
		User.update_via_omniauth!(env["omniauth.auth"], current_user)
		redirect_to root_path	
	end

	def logout
		session = nil
		@current_user = nil
		logout_url = root_path
		RubyCAS::Filter.logout(self, root_path)
	end

	def index
		@schedules = Schedule.where("user_id = ?", @current_user.id)
	end

	def show
		@schedule = Schedule.find(params[:id])
	end

	def new
		@schedule = Schedule.new
	end

	def edit
		@id = params[:id]		
	  if @id.nil?
      @schedule = Schedule.find(current_user.id)
    else
      @schedule = Schedule.find(@id)
    end
	end

	def create		
		@schedule = Schedule.new(schedule_params)
		@schedule.user_id = current_user.id
		@schedule.day = Time.now.strftime("%A")

		respond_to do |format|
      if @schedule.save
        format.html { redirect_to schedules_path}
        format.json { render action: 'show', status: :created, location: @schedule }
      else
        format.html { render action: 'new' }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end
	end

	def update
		@schedule = Schedule.find(params[:id])
		respond_to do |format|
      if @schedule.update(schedule_params)
        format.html { redirect_to schedules_path}
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @schedule.errors, status: :unprocessable_entity }
      end
    end	
	end

	def destroy		
	end

	private

	def schedule_params
		params.require(:schedule).permit(:start_time, :end_time, :location)
	end
end