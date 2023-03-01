module SessionHelper

  def login_ext(externo)
    session[:login] = externo.loginUsuario
  end

  def logout_ext
    session.destroy
    @current_user = nil
  end

  # def current_user_ext
  #   @current_user ||= Usuario.find_by(id: session[:login])
  # end

  # def logged_in_ext
  #   !current_usuario_ext.nil?
  # end

end
