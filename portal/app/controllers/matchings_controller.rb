class MatchingsController < ApplicationController
  def create
  	match = User.find(params[:match_id])
    if match.matchings.pending.find_by(match_id: current_user.id)
    	match.matchings.pending.find_by(match_id: current_user.id).update_attribute(:status, 'accepted')
    	current.user.matchings.create(match_id: match.id, status: 'accepted')
    else
	    current_user.matchings.create(match_id: params[:match_id], status: 'pending')
	    respond_to do |format|
	        format.html { redirect_to users_path, notice: 'Match preference noted.' }
	    end
	  end
  end
  
  def destroy
    @matching = current_user.matchings.find(params[:matching_id])
    @matching.destroy
    respond_to do |format|
      format.html { redirect_to users_path }
      format.json { head :no_content }
    end
  end

  private
       # Never trust parameters from the scary internet, only allow the white list through.
    def matching_params
      params.require(:matching).permit(:user_id, :match_id, :create, :destroy)
    end
end
