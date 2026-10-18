class SettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :prepare_forms

  def show
  end

  def update
    remove_avatar = params[:remove_avatar] == "1"
    attributes = profile_params
    replacing_avatar = attributes[:avatar].present?
    @profile_user.assign_attributes(attributes)

    if @profile_user.save
      @profile_user.avatar.purge if remove_avatar && !replacing_avatar
      redirect_to settings_path, notice: "Профиль обновлён"
    else
      @profile_errors = @profile_user.errors.full_messages
      render :show, status: :unprocessable_entity
    end
  end

  def update_password
    if current_user.update_with_password(password_params)
      bypass_sign_in(current_user)
      redirect_to settings_path, notice: "Пароль изменён"
    else
      @password_errors = current_user.errors.full_messages.map do |error|
        error.match?(/current password/i) ? "Текущий пароль указан неверно" : error
      end.uniq
      render :show, status: :unprocessable_entity
    end
  end

  private

  def prepare_forms
    @profile_user = current_user
    @profile_errors ||= []
    @password_errors ||= []
  end

  def profile_params
    params.require(:user).permit(:name, :phone, :city, :avatar)
  end

  def password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
