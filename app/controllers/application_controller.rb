class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    include WelcomeHelper
    include SessionHelper


    def autenticado?
      if session[:login].blank? 
        redirect_to root_path, notice: "Por favor, faça o login para acesso."
        return false
      end
    end
    
end
