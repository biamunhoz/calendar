class SessionController < ApplicationController

  def new
    logout_ext_url
    session[:login] = nil
  end

  #implementação do OAuth2 para Google
  def google_auth
    client_id = Google::Auth::ClientId.new(ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'])
    redirect_uri = ENV['GOOGLE_REDIRECT_URI'] || 'http://localhost:3000/oauth2/callback'
    scope = ['https://www.googleapis.com/auth/gmail.send']

    token_store = Google::Auth::Stores::FileTokenStore.new(file: Rails.root.join('tmp/gmail_token.yaml'))
    authorizer = Google::Auth::WebUserAuthorizer.new(client_id, scope, token_store, redirect_uri)

    user_id = session[:login] || 'default'
    credentials = authorizer.get_credentials(user_id, request)

    if credentials.nil?
      redirect_to authorizer.get_authorization_url(request: request)
    else
      render plain: "Credenciais já armazenadas para #{user_id}."
    end
  end

  #função callback para receber o código de autorização do Google
  def callback
    client_id = Google::Auth::ClientId.new(ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'])
    redirect_uri = ENV['GOOGLE_REDIRECT_URI'] || 'http://localhost:3000/oauth2/callback'
    scope = ['https://www.googleapis.com/auth/gmail.send']

    token_store = Google::Auth::Stores::FileTokenStore.new(file: Rails.root.join('tmp/gmail_token.yaml'))
    authorizer = Google::Auth::WebUserAuthorizer.new(client_id, scope, token_store, redirect_uri)

    user_id = session[:login] || 'default'

    begin
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id,
        code: params[:code],
        base_url: redirect_uri
      )
      render plain: "Tokens armazenados com sucesso para #{user_id}."
    rescue => e
      Rails.logger.error "Erro ao armazenar tokens: #{e.message}"
      render plain: "Erro ao armazenar tokens."
    end
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
