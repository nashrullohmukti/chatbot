class Company < ApplicationRecord
  has_many :users, dependent: :destroy

  # after_create :add_company_to_apartment

  def self.current
    company = Company.find_by domain:Apartment::Tenant.current
    raise ::Apartment::TenantNotFound, "Unable to find company" unless company
    company
  end

  def switch!
    Apartment::Tenant.switch! domain
  end

  private
    def add_company_to_apartment
      Apartment::Tenant.create(domain)
    end

    def drop_company_from_apartment
      Apartment::Tenant.drop(domain)
    end
end
