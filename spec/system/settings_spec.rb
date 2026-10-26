# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Настройки пользователя", type: :system do
  let(:user) { create(:user, password: "password123", password_confirmation: "password123") }

  before do
    sign_in user
    visit settings_path
  end

  it "обновляет имя, телефон и город" do
    fill_in "Имя", with: "Новое имя"
    fill_in "Телефон", with: "+79998887766"
    fill_in "Город", with: "Казань"  # Надо изменить самое поле города на список и справить на select
    click_button "Сохранить профиль"

    expect(page).to have_content("Профиль обновлён")
    expect(user.reload).to have_attributes(name: "Новое имя", phone: "+79998887766", city: "Казань")
  end

  it "загружает и удаляет аватар" do
    attach_file "user_avatar", Rails.root.join("spec/fixtures/files/small.png")
    click_button "Сохранить профиль"

    expect(user.reload.avatar).to be_attached

    check "Удалить аватар"
    click_button "Сохранить профиль"

    expect(user.reload.avatar).not_to be_attached
  end

  it "меняет пароль и оставляет пользователя авторизованным" do
    fill_in "Текущий пароль", with: "password123"
    fill_in "Новый пароль", with: "new-password123"
    fill_in "Повторите пароль", with: "new-password123"
    click_button "Сменить пароль"

    expect(page).to have_content("Пароль изменён")
    expect(page).to have_content(user.reload.name)
    expect(user.reload.valid_password?("new-password123")).to be(true)
  end

  it "показывает ошибку при неверном текущем пароле" do
    fill_in "Текущий пароль", with: "wrong-password"
    fill_in "Новый пароль", with: "new-password123"
    fill_in "Повторите пароль", with: "new-password123"
    click_button "Сменить пароль"

    expect(page).to have_content("Текущий пароль указан неверно")
    expect(user.reload.valid_password?("password123")).to be(true)
  end

  it "показывает ошибку при несовпадении подтверждения" do
    fill_in "Текущий пароль", with: "password123"
    fill_in "Новый пароль", with: "new-password123"
    fill_in "Повторите пароль", with: "different-password123"
    click_button "Сменить пароль"

    expect(page).to have_content("Подтверждение пароля не совпадает")
    expect(user.reload.valid_password?("password123")).to be(true)
  end
end
