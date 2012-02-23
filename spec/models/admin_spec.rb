require "spec_helper"

describe Admin do
  it { should respond_to :hashed_password }
  it { should respond_to :password }
  it { should respond_to :password_confirmation }
  it { should respond_to :salt }

  it "should not be saved" do
    Admin.new.save.should be_false
  end

  it "should be created" do
    Admin.create!({
      :login => "teste",
      :password => "123456",
      :password_confirmation => "123456"
    }).should be_true
  end

  it "must have a login" do
    Admin.new({
      :password => "123456",
      :password_confirmation => "123456"
    }).should_not be_valid
  end

  it "must have a password" do
    Admin.new({
      :login => "teste",
      :password_confirmation => "123456"
    }).should_not be_valid
  end

  it "must have a password confirmation" do
    Admin.new({
      :login => "teste",
      :password => "123456",
      :password_confirmation => ""
    }).should_not be_valid
  end

  it "must have a unique login" do
    Admin.create!({
      :login => "unique",
      :password => "123456",
      :password_confirmation => "123456"
    }).should be_true

    Admin.new({
      :login => "unique",
      :password => "123456",
      :password_confirmation => "123456"
    }).should_not be_valid
  end

  describe "#password=" do
    it "should define salt and hashed_password attributes" do
      Admin.should_receive(:random_string)
           .with(32)
           .and_return("random string")

      Admin.should_receive(:encrypt)
           .with("my password", "random string")
           .and_return("sha")

      admin = Admin.new
      admin.password = "my password"

      admin.salt.should == "random string"
      admin.hashed_password.should == "sha"
    end
  end

  describe ".authenticate" do
    before do
      Admin.create!({
        :login => "test",
        :password => "123456"
      })
    end

    it "should return false when login and password are not valid" do
      Admin.authenticate("foo", "bar").should be_false
    end

    it "should return false when login is not valid" do
      Admin.authenticate("test_", "123456").should be_false
    end

    it "should return false when password is not valid" do
      Admin.authenticate("test", "1234567").should be_false
    end

    it "should return true when login and password are valid" do
      Admin.authenticate("test", "123456").should be_kind_of Admin
    end
  end

  it "should not persist the user password" do
    Admin.create!({
      :login => "test",
      :password => "123456",
      :password_confirmation => "123456"
    })

    admin = Admin.first(:conditions => {:login => "test"})
    admin.password.should be_nil
    admin.password_confirmation.should be_nil
  end

  describe ".random_string" do
    it "should return a string with given length" do
      Admin.random_string(199).size.should == 199
      Admin.random_string(10).size.should == 10
    end
  end

  describe ".encrypt" do
    it "should return a hashed version of the given login and password" do
      Digest::SHA512.should_receive(:hexdigest).with("foobar@123456").and_return("hashed version")

      Admin.encrypt("foobar", "123456").should == "hashed version"
    end
  end
end
