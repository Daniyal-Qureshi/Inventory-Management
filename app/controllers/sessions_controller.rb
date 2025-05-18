class SessionsController < ApplicationController
  def new
  end

  def create
    employee = Employee.find_by(access_code: access_code_param[:access_code])
    
    if employee
      sign_in_as(employee)
      redirect_based_on_role(employee)
    else
      redirect_to request.path, alert: "Invalid access code"
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

  private
  
  def access_code_param
    params.require(:session).permit(:access_code)
  end
  
  def redirect_based_on_role(employee)
    if employee.customer_service?
      redirect_to customer_service_index_path
    else
      redirect_to employees_path
    end
  end
end
