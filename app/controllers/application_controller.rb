class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_current_tenant

  # load_and_authorize_resource

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_path, :alert => exception.message
  end

  def after_sign_in_path_for(resource)
    if current_user.role.eql?('admin') && current_user.company.present? && current_user.company.name.nil?
      edit_company_path(current_user.company)
    else
      root_path(current_user)
    end
  end

  protected

  def set_current_tenant
    if user_signed_in? && current_user.company.present?
      if current_user.company.domain.present?
        Apartment::Tenant.switch!(current_user.company.domain)
      else
        unless (params[:controller].eql?("companies") && params[:action].eql?("edit") || params[:action].eql?("update")) || params[:controller].include?('devise')
          redirect_to edit_company_path(current_user.company), alert: "Please complete your company profile "
        end
      end
    else
      Apartment::Tenant.switch!("public")
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :role])
  end
end
