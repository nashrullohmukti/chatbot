class User < ApplicationRecord
  ROLES = %i[super_admin admin customer]
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :confirmable, :invitable,
         :omniauthable, :omniauth_providers => [:google_oauth2, :facebook]

  belongs_to :company

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      # user.image = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      user.skip_confirmation!
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def is_admin?
    role == 'admin'
  end

  def is_super_admin?
    role == 'super_admin'
  end

  def is_customer?
    role == 'customer'
  end

  def has_company?
    company.present? && company.domain.present?
  end
end
