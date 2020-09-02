class SessionsController < ApplicationController
  def new
  end

  def create
    employee = Employee.find_by(access_code: access_code_param[:access_code])

    if employee
      sign_in_as(employee)
      redirect_to employees_path
    else
      render :new
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  def access_code_param
    params.require(:session).permit(:access_code)
  end
end
