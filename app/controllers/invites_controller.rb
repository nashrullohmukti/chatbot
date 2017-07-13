class InvitesController < ApplicationController
	before_action :authenticate_user!

	def index
	end

  def invite
    User.invite!(:email => params[:email])
  end
end
