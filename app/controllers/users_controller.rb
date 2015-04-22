class UsersController < ApplicationController
  def upload
    @user = current_user
    if params[:scans]
      ActiveRecord::Base.transaction do
        params[:scans].each do |scan|
          @user.scanned_quizzes.create(scan: scan)
        end
      end
      flash[:success] = "Files were successfully uploaded"
    else 
      flash[:alert] = "No files were selected"
    end
    redirect_to :back
  end
end
