class MatchingsController < ApplicationController
  before_action :set_user, only: [:create] 
  skip_before_action :update_existing_user

  def create
    Matching.create(user_id: current_user.id, match_id: @user.id, status: 'pending')
    respond_to do |format|
      format.html { redirect_to users_path }
    end
  end

  # def match
  # 	match = User.find(params[:match_id])
  #   if match.matchings.pending.find_by(match_id: current_user.id)
  #   	match.matchings.pending.find_by(match_id: current_user.id).update_attribute(:status, 'accepted')
  #   	current_user.matchings.create(match_id: match.id, status: 'accepted')
  #   else
	 #    current_user.matchings.create(match_id: params[:match_id], status: 'pending')
	 #    respond_to do |format|
	 #        format.html { redirect_to users_path, notice: 'Match preference noted.' }
	 #    end
	 #  end
  # end
  
  def destroy
    @matching = Matching.find(params[:id])
    @matching.destroy
    respond_to do |format|
      format.html { redirect_to matchings_path }
      format.json { head :no_content }
    end
  end

  def index
    @matchings = Matching.all
  end

  private
       # Never trust parameters from the scary internet, only allow the white list through.

    def set_user
        @user = User.find(params[:match_id])
    end
       
    def matching_params
      params.require(:matching).permit(:user_id, :match_id, :create, :destroy)
    end

end
