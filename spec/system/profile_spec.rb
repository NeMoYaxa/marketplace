# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Профиль пользователя", type: :system do
  let!(:category) { create(:category) }
  let(:user) { create(:user, name: "Текущий пользователь") }

  before { sign_in user }

  it "показывает только объявления текущего пользователя и счётчики" do
    active = create(:listing, user: user, category: category, title: "Моё активное")
    create(:listing, :sold, user: user, category: category, title: "Моё проданное")
    create(:listing, :archived, user: user, category: category, title: "Моё архивное")
    create(:listing, category: category, title: "Чужое объявление")

    visit profile_path

    expect(page).to have_content(user.name)
    expect(page).to have_content("Активные 1")
    expect(page).to have_content("Проданные 1")
    expect(page).to have_content("Архив 1")
    expect(page).to have_content(active.title)
    expect(page).not_to have_content("Чужое объявление")
    expect(page).to have_link("Редактировать", href: edit_listing_path(active))
    expect(page).to have_button("Изменить статус")
    expect(page).to have_link("Удалить", href: listing_path(active))
  end

  it "фильтрует объявления вкладками" do
    create(:listing, user: user, category: category, title: "Активное")
    create(:listing, :sold, user: user, category: category, title: "Проданное")
    create(:listing, :archived, user: user, category: category, title: "Архивное")

    visit profile_path(status: "sold")
    expect(page).to have_content("Проданное")
    expect(page).not_to have_content("Активное")

    visit profile_path(status: "archived")
    expect(page).to have_content("Архивное")
    expect(page).not_to have_content("Проданное")
  end

  it "показывает пустое состояние" do
    visit profile_path

    expect(page).to have_content("В этом разделе пока нет объявлений")
    expect(page).to have_link("Разместить объявление", href: new_listing_path)
  end
end
