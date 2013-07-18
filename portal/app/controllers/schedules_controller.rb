class SchedulesController < ApplicationController
	before_action :current_user

	def index
		@schedules = Schedule.where("user_id = ?", @current_user.id)
	end

	def show
		# @schedule = Schedule.find(params[:id])
	end

	def new
		@schedule = Schedule.new
	end

	def edit
		@id = params[:id]		
	end

	def create		
		@schedule = Schedule.new(schedule_params)

	end

	def update		
	end

	def destroy		
	end

	private

	def schedule_params
		params.require(:schedule).permit(:user_id, :day, :time, :location)
	end
end