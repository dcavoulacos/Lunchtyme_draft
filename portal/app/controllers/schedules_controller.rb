class SchedulesController < ApplicationController
	def index
		@schedules = Schedule.where("user_id = ?", @current_user)
	end

	def show
		@schedule = Schedule.find(params[:id])
	end

	def new
	end

	def edit		
	end

	def update		
	end

	def destroy		
	end
end