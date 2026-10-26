# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Объявления", type: :system do
  let!(:category) { create(:category) }
  let(:user) { create(:user) }

  before { sign_in user }

  it "создаёт объявление без фотографии" do
    visit new_listing_path

    select category.name, from: "Категория"
    fill_in "Заголовок", with: "Новый товар"
    fill_in "Описание", with: "Подробное описание товара"
    fill_in "Цена", with: "2500"
    select "Москва", from: "Город"
    click_button "Опубликовать"

    expect(page).to have_content("Новый товар")
    expect(page).to have_content("Объявление опубликовано")
    expect(Listing.find_by(title: "Новый товар", user: user)).to be_present
  end

  it "создаёт объявление с фотографией" do
    visit new_listing_path

    select category.name, from: "Категория"
    fill_in "Заголовок", with: "Товар с фото"
    attach_file "listing_images", Rails.root.join("spec/fixtures/files/small.png")
    click_button "Опубликовать"

    listing = Listing.find_by(title: "Товар с фото", user: user)
    expect(listing).to be_present
    expect(listing.images).to be_attached
    expect(page).to have_content("Товар с фото")
  end

  it "редактирует и удаляет своё объявление" do
    listing = create(:listing, user: user, category: category, title: "Старый заголовок")

    visit edit_listing_path(listing)
    fill_in "Заголовок", with: "Обновлённый заголовок"
    click_button "Сохранить"

    expect(page).to have_content("Обновлённый заголовок")
    expect(listing.reload.title).to eq("Обновлённый заголовок")

    expect do
      page.driver.submit :delete, listing_path(listing), {}
    end.to change(Listing, :count).by(-1)

    expect(page).to have_content("Объявление удалено")
  end

  it "не показывает владельческие действия на чужом объявлении" do
    listing = create(:listing, category: category)

    visit listing_path(listing)

    expect(page).not_to have_link("Редактировать")
    expect(page).not_to have_button("Изменить статус")
    expect(page).not_to have_link("Удалить")
  end

  it "не открывает форму редактирования чужого объявления" do
    listing = create(:listing, category: category)

    visit edit_listing_path(listing)

    expect(page.status_code).to eq(404)
    expect(page).not_to have_field("Заголовок")
  end
end
