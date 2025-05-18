class ApplicationController < ActionController::Base
  def current_user
    if session[:employee_id]
      Employee.find_by(id: session[:employee_id])
    end
  end

  helper_method :current_user

  def signed_in?
    current_user.present?
  end

  helper_method :signed_in?

  def require_signin
    if signed_out?
      redirect_to sign_in_path
    end
  end

  def sign_in_as(employee)
    session[:employee_id] = employee.id
  end

  def sign_out
    session[:employee_id] = nil
  end

  def signed_out?
    !signed_in?
  end

  def require_warehouse_employee
    redirect_to root_path, alert: "Access denied" unless current_user&.warehouse?
  end

  def require_customer_service_employee
    redirect_to root_path, alert: "Access denied" unless current_user&.customer_service?
  end
end
