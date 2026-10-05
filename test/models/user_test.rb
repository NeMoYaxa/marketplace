require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid user" do
    assert_predicate users(:one), :valid?
  end

  test "requires name" do
    user = build_user(name: nil)

    refute_predicate user, :valid?
    assert user.errors.added?(:name, :blank)
  end

  test "requires a name between four and fifty characters" do
    user = build_user(name: "Joe")
    refute_predicate user, :valid?
    assert user.errors[:name].any?

    user.name = "a" * 51
    refute_predicate user, :valid?
    assert user.errors[:name].any?
  end

  test "validates phone format when provided" do
    user = build_user

    user.phone = "invalid"
    refute_predicate user, :valid?
    assert user.errors[:phone].any?

    user.phone = "+79991234567"
    assert_predicate user, :valid?
  end

  test "allows blank phone" do
    user = build_user(phone: "")

    assert_predicate user, :valid?
  end

  test "requires email" do
    user = build_user(email: nil)

    refute_predicate user, :valid?
    assert user.errors.added?(:email, :blank)
  end

  test "validates unique email" do
    user = build_user(email: users(:one).email)

    refute_predicate user, :valid?
    assert_includes user.errors.details[:email].map { _1[:error] }, :taken
  end

  test "requires password for new user" do
    user = build_user(password: nil, password_confirmation: nil)

    refute_predicate user, :valid?
    assert user.errors[:password].any?
  end

  test "requires minimum password length" do
    user = build_user(password: "short", password_confirmation: "short")

    refute_predicate user, :valid?
    assert user.errors[:password].any?
  end

  test "defines user roles" do
    assert_equal %w[user admin], User.roles.keys
  end

  test "has expected enum mappings for roles" do
    assert_equal 0, User.roles["user"]
    assert_equal 1, User.roles["admin"]
  end

  test "supports role predicates and transitions" do
    user = users(:one)

    assert_predicate user, :user?
    user.admin!
    assert_predicate user, :admin?
  end

  test "raises on invalid role assignment" do
    user = users(:one)

    assert_raises(ArgumentError) { user.role = :superadmin }
  end

  test "returns favorite listings through favorites association" do
    user = users(:one)

    assert_includes user.favorite_listings, listings(:one)
  end

  test "declares dependent destroy for listings and favorites" do
    listings_association = User.reflect_on_association(:listings)
    favorites_association = User.reflect_on_association(:favorites)

    assert_equal :destroy, listings_association.options[:dependent]
    assert_equal :destroy, favorites_association.options[:dependent]
  end

  private

  def build_user(**attrs)
    token = SecureRandom.hex(6)
    defaults = {
      email: "user-#{token}@example.com",
      password: "password123",
      password_confirmation: "password123",
      name: "User #{token}",
      phone: "+79991234567"
    }
    User.new(**defaults.merge(attrs))
  end
end
