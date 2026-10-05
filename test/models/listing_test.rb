require "test_helper"

class ListingTest < ActiveSupport::TestCase
  test "valid listing" do
    assert_predicate listings(:one), :valid?
  end

  test "requires a title" do
    listing = Listing.new(user: users(:one), category: categories(:one))

    refute_predicate listing, :valid?
    assert listing.errors.added?(:title, :blank)
  end

  test "requires user" do
    listing = Listing.new(category: categories(:one), title: "No user")

    refute_predicate listing, :valid?
    assert listing.errors.added?(:user, :blank)
  end

  test "requires category" do
    listing = Listing.new(user: users(:one), title: "No category")

    refute_predicate listing, :valid?
    assert listing.errors.added?(:category, :blank)
  end

  test "accepts only non-negative integer prices" do
    listing = Listing.new(user: users(:one), category: categories(:one), title: "Item")

    listing.price = -1
    refute_predicate listing, :valid?
    assert listing.errors[:price].any?

    listing.price = 10.5
    refute_predicate listing, :valid?
    assert listing.errors[:price].any?
  end

  test "allows nil price" do
    listing = Listing.new(user: users(:one), category: categories(:one), title: "Without price", price: nil)

    assert_predicate listing, :valid?
  end

  test "allows zero price" do
    listing = Listing.new(user: users(:one), category: categories(:one), title: "Free item", price: 0)

    assert_predicate listing, :valid?
  end

  test "defines listing statuses" do
    assert_equal %w[active sold archived], Listing.statuses.keys
  end

  test "has expected enum mappings for status" do
    assert_equal 0, Listing.statuses["active"]
    assert_equal 1, Listing.statuses["sold"]
    assert_equal 2, Listing.statuses["archived"]
  end

  test "supports status predicates and transitions" do
    listing = listings(:one)

    assert_predicate listing, :active?
    listing.sold!
    assert_predicate listing, :sold?
  end

  test "raises on invalid status assignment" do
    listing = listings(:one)

    assert_raises(ArgumentError) { listing.status = :unknown }
  end

  test "declares dependent destroy for favorites" do
    association = Listing.reflect_on_association(:favorites)

    assert_equal :destroy, association.options[:dependent]
  end
end
