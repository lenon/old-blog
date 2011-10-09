require "test/helper"

class AdminTest < Test::Unit::TestCase
  def setup
    Admin.delete_all
  end

  def test_admin_expected_attributes
    assert(Admin.new.respond_to?(:hashed_password))
    assert(Admin.new.respond_to?(:password))
    assert(Admin.new.respond_to?(:password_confirmation))
    assert(Admin.new.respond_to?(:salt))
  end

  def test_admin_without_any_attributes
    assert(!Admin.new.valid?)
  end

  def test_admin_without_login
    admin = Admin.new({
      :password => "123456",
      :password_confirmation => "123456"
    })
    assert(!admin.valid?)
  end

  def test_admin_without_password
    admin = Admin.new({
      :login => "teste",
      :password_confirmation => "123456"
    })
    assert(!admin.valid?)
  end

  def test_admin_without_password_confirmation
    admin = Admin.new({
      :login => "teste",
      :password => "123456",
      :password_confirmation => ""
    })
    assert(!admin.valid?)
  end

  def test_admin_creation
    assert_nothing_raised do
      Admin.create!({
        :login => "teste",
        :password => "123456",
        :password_confirmation => "123456"
      })
    end
  end

  def test_unique_login
    Admin.create!({
      :login => "unique",
      :password => "123456",
      :password_confirmation => "123456"
    })

    assert_raise Mongoid::Errors::Validations do
      Admin.create!({
        :login => "unique",
        :password => "123456",
        :password_confirmation => "123456"
      })
    end
  end

  def test_salt_attribute
    Admin.expects(:random_string).returns("random")
    admin = Admin.new({
      :password => "123456"
    })
    assert_equal("random", admin.salt)
  end

  def test_hashed_password_attribute
    Admin.expects(:encrypt).returns("my_password")
    admin = Admin.new({
      :password => "123456"
    })
    assert_equal("my_password", admin.hashed_password)
  end

  def test_authenticate_with_invalid_params
    assert(!Admin.authenticate("foo", "bar"))
  end

  def test_authenticate_with_wrong_login
    Admin.create!({
      :login => "test",
      :password => "123456"
    })
    assert(!Admin.authenticate("test_", "123456"))
  end

  def test_authenticate_with_wrong_password
    Admin.create!({
      :login => "test",
      :password => "123456"
    })
    assert(!Admin.authenticate("test", "1234567"))
  end

  def test_authenticate_with_valid_params
    Admin.create!({
      :login => "test",
      :password => "123456"
    })
    admin = Admin.authenticate("test", "123456")
    assert(admin.is_a?(Admin))
    assert_equal("test", admin.login)
  end
end
