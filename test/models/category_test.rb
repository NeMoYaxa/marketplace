require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "valid category" do
    assert_predicate categories(:one), :valid?
  end

  test "requires name" do
    category = Category.new(slug: unique_slug("only-slug"))

    refute_predicate category, :valid?
    assert category.errors.added?(:name, :blank)
  end

  test "requires slug" do
    category = Category.new(name: "Only name")

    refute_predicate category, :valid?
    assert category.errors.added?(:slug, :blank)
  end

  test "requires a unique slug" do
    category = Category.new(name: "Another category", slug: categories(:one).slug)

    refute_predicate category, :valid?
    assert_includes category.errors.details[:slug].map { _1[:error] }, :taken
  end

  test "allows category without parent" do
    category = Category.new(name: "Standalone", slug: unique_slug("standalone"))

    assert_predicate category, :valid?
  end

  test "supports parent and subcategories association" do
    parent = create_category(name: "Vehicles")
    child = create_category(name: "Cars", parent: parent)

    assert_equal parent, child.parent
    assert_includes parent.subcategories, child
  end

  test "nullifies parent_id of subcategories when parent is destroyed" do
    parent = create_category(name: "Parent")
    child = create_category(name: "Child", parent: parent)

    parent.destroy!
    child.reload

    assert_nil child.parent_id
  end

  test "declares dependent destroy for listings" do
    association = Category.reflect_on_association(:listings)

    assert_equal :destroy, association.options[:dependent]
  end

  private

  def create_category(name:, parent: nil)
    token = SecureRandom.hex(4)
    Category.create!(
      name: "#{name} #{token}",
      slug: unique_slug(name),
      parent: parent
    )
  end

  def unique_slug(base)
    "#{base.parameterize}-#{SecureRandom.hex(4)}"
  end
end
