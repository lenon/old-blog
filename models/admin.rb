class Admin
  include Mongoid::Document
  include Mongoid::Timestamps

  field :login
  field :hashed_password
  field :salt

  validates_presence_of :login
  validates_uniqueness_of :login

  validates_presence_of :password
  validates_confirmation_of :password

  attr_accessor :password, :password_confirmation

  def self.authenticate(login, password)
    admin = Admin.first(:conditions => {:login => login})
    if admin && Admin.encrypt(password, admin.salt) == admin.hashed_password
      return admin
    end
    false
  end

  def password=(password)
    @password = password
    self.salt = Admin.random_string(32) if !self.salt
    self.hashed_password = Admin.encrypt(@password, self.salt)
  end

  protected

  def self.encrypt(password, salt)
    Digest::SHA512.hexdigest("#{password}@#{salt}")
  end

  def self.random_string(length)
    rand(36**length).to_s(36)
  end
end
