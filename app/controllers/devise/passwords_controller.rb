class Devise::PasswordsController < ApplicationController
  skip_before_filter :authorize_user
  prepend_before_filter :require_no_authentication
  include Devise::Controllers::InternalHelpers

  # GET /resource/password/new
  def new
    build_resource({})
    render_with_scope :new
  end

  # POST /resource/password
  def create
    if params[:user] and params[:user][:username]
   #   set_flash_message(:alert, :send_instructions) if is_navigational_format?
      set_flash_message(:alert, :send_instructions) if is_navigational_format?
      self.resource = resource_class.send_reset_password_instructions(params[resource_name])
    else
  #    set_flash_message(:alert, :email_instructions) if is_navigational_format?
      self.resource = resource_class.send_reset_password_instructions(params[resource_name],'username_req')
    end
    if successful_and_sane?(resource)
      #set_flash_message(:alert, :send_instructions) if is_navigational_format?
      respond_with({}, :location => after_sending_reset_password_instructions_path_for(resource_name))
    else
      @userexist=User.where(" username = ?" , params[resource_name][:username])		
      if @userexist.size < 1		
	set_flash_message(:notice, :username_not_found)
      else
 	@emailexist=User.where(" email = ?" , params[resource_name][:email])
	if @emailexist.size == 0
          set_flash_message(:notice, :email_not_found)
	end	
      end		
      respond_with_navigational(resource){ render_with_scope :new }
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    self.resource = resource_class.new
    resource.reset_password_token = params[:reset_password_token]
    render_with_scope :edit
  end

  # PUT /resource/password
  def update
    self.resource = resource_class.reset_password_by_token(params[resource_name])

    if resource.errors.empty?
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message(:notice, flash_message) if is_navigational_format?
      sign_in(resource_name, resource)
      respond_with resource, :location => redirect_location(resource_name, resource)
    else
      respond_with_navigational(resource){ render_with_scope :edit }
    end
  end

  protected

  # The path used after sending reset password instructions
  def after_sending_reset_password_instructions_path_for(resource_name)
    "/user/sign_in"
#      new_session_path(resource_name)
  end

end
