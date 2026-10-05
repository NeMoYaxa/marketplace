require "test_helper"

class FavoriteTest < ActiveSupport::TestCase
  test "valid favorite" do
    assert_predicate favorites(:one), :valid?
  end

  test "belongs to a user and listing" do
    favorite = favorites(:one)

    assert_equal users(:one), favorite.user
    assert_equal listings(:one), favorite.listing
  end

  test "does not allow the same listing to be favorited twice by one user" do
    favorite = Favorite.new(user: users(:one), listing: listings(:one))

    refute_predicate favorite, :valid?
    assert favorite.errors.added?(:user_id, :taken, value: users(:one).id)
  end

  test "allows different users to favorite the same listing" do
    favorite = Favorite.new(user: users(:two), listing: listings(:one))

    assert_predicate favorite, :valid?
  end

  test "requires user" do
    favorite = Favorite.new(listing: listings(:one))

    refute_predicate favorite, :valid?
    assert favorite.errors.added?(:user, :blank)
  end

  test "requires listing" do
    favorite = Favorite.new(user: users(:one))

    refute_predicate favorite, :valid?
    assert favorite.errors.added?(:listing, :blank)
  end
end
