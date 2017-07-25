class InvitesController < ApplicationController
	before_action :authenticate_user!

	def index
	end

  def invite
		yyy
    User.invite!(:email => params[:email], :company_id => current_user[:company_id])
  end
end
