# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Гостевой доступ", type: :system do
  let!(:category) { create(:category) }

  describe "главная страница" do
    it "показывает активные объявления" do
      listing = create(:listing, category: category, title: "Велосипед для города")

      visit root_path

      expect(page).to have_content("Велосипед для города")
      expect(page).to have_link(href: listing_path(listing))
    end
  end

  describe "защищённые страницы" do
    it "перенаправляет гостя на вход" do
      [ new_listing_path, profile_path, settings_path ].each do |path|
        visit path

        expect(page).to have_current_path(new_user_session_path)
        expect(page).to have_content("Добро пожаловать")
      end
    end
  end

  describe "регистрация и вход" do
    it "регистрирует нового пользователя" do
      visit new_user_registration_path

      fill_in "Ваше имя", with: "Новый пользователь"
      fill_in "Электронная почта", with: "new-user@example.com"
      fill_in "registration-password", with: "password123"
      fill_in "registration-password-confirmation", with: "password123"
      click_button "Создать аккаунт"

      expect(page).to have_content("Новый пользователь")
      expect(User.find_by(email: "new-user@example.com")).to be_present
    end

    it "выполняет вход существующего пользователя" do
      user = create(:user, email: "login@example.com", password: "password123")

      visit new_user_session_path
      fill_in "Электронная почта", with: user.email
      fill_in "login-password", with: "password123"
      click_button "Войти"

      expect(page).to have_content(user.name)
      expect(page).to have_link("Разместить объявление", href: new_listing_path)
    end
  end
end
