class InvitesController < ApplicationController
  def index
    User.invite!(:email => params[:email])
  end
end
