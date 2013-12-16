module Tokenable
  extend ActiveSupport::Concern

  included do
    before_create :generate_token
  end

  def generate_token
    begin
      self.token = SecureRandom.urlsafe_base64
    end while self.class.exists?(token: self.token)
  end
end