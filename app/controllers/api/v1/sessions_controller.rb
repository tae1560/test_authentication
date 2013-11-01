class Api::V1::SessionsController < Devise::SessionsController
  skip_before_filter :verify_authenticity_token,
                    :if => Proc.new { |c| c.request.format == 'application/json' }
  #skip_before_filter :verify_authenticity_token

  respond_to :json

  def create
    #Rails.logger.error "resource_name : #{warden}"
    #warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    # TODO - custom : http://stackoverflow.com/questions/5166268/advice-on-http-authentication-scheme-using-request-headers
    if Util.text_is_not_empty?(params[:uid]) and Util.text_is_not_empty?(params[:access_token])
      user = User.find_or_create_user_by_uid params[:uid], params[:access_token]
      user.save!

      # current_user 조절 : http://stackoverflow.com/questions/5924435/how-do-i-set-current-user-even-though-a-user-is-not-logged-in-rails-3
      sign_in(user)
    else
      failure
      return
    end

    render :status => 200,
           :json => { :success => true,
                      :info => "Logged in",
                      :data => { :auth_token => current_user.authentication_token } }
  end

  def destroy
    #warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    unless current_user
      failure
      return
    end
    current_user.update_column(:authentication_token, nil)
    sign_out(current_user)
    render :status => 200,
           :json => { :success => true,
                      :info => "Logged out",
                      :data => {} }
  end

  def failure
    render :status => 401,
           :json => { :success => false,
                      :info => "Login Failed",
                      :data => {} }
  end
end
