class SettingsController < ApplicationController
  before_action :set_setting, only: [:new, :create, :edit, :update]
  before_action :authenticate_user!

  def edit
  end

  def update
    respond_to do |format|
      if @setting.update(setting_params)
        format.html { redirect_to user_path(@setting.user), notice: t(:'setting.updated') }
        format.json { render :show, status: :ok, location: @setting.user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_setting
    @setting = Setting.find(params[:id])
  end

  def setting_params
    params.require(:setting).permit(:has_darkmode, :default_locale)
  end
end
