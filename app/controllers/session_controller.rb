class SessionController < ApplicationController


  def new
    #fabi correção
    logout_ext_url
    session[:login] = nil
  end

  def create

    externo = Usuario.find_by(emailPrincipalUsuario: params[:session][:email].downcase)
    if externo && externo.authenticate(params[:session][:password])
      login_ext externo
      @agendas = Agenda.where(apresentacaotelaini: true)
      #@inscricao = Inscricao.joins(:usuario).joins(:agenda).where("usuarios.loginUsuario = ? ", session[:login])
      #.select("usertipo, agenda_id, inscricaos.tipo")
      #redirect_to agendas_path
    else
      flash[:notice] = 'Usuário ou senha inválida'
      render 'new'
    end
  end

  def destroy
    logout_ext_url
    redirect_to root_path
  end

end
