class TesteEnvioController < ApplicationController
  
  # O TesteEnvioController é responsável por enviar e-mails de teste usando o Gmail API.
  # Ele utiliza o TesteMailer para compor o e-mail e o Google API Client para enviar o e-mail.

  require 'mail'
  require 'base64'

  REDIRECT_URI = 'http://localhost:3000/oauth2/callback'

  def enviar
    TesteMailer.teste.deliver_now
    render plain: 'E-mail de teste enviado com sucesso!'
  rescue => e
    render plain: "Erro ao enviar e-mail: #{e.message}"
  end

  def gmail_service
    client_id = Google::Auth::ClientId.from_file(Rails.root.join('config/client_secret.json'))
    token_store = Google::Auth::Stores::FileTokenStore.new(file: 'tmp/gmail_token.yaml')

    authorizer = Google::Auth::WebUserAuthorizer.new(client_id, ['https://www.googleapis.com/auth/gmail.send'], token_store, REDIRECT_URI)

    user_id = session[:login] || 'default'
    credentials = authorizer.get_credentials(user_id, request)

    raise "Credenciais não encontradas para #{user_id}" if credentials.nil?

    service = Google::Apis::GmailV1::GmailService.new
    service.authorization = credentials
    service
  end

  def enviar_email
    service = gmail_service

    # Gera o e-mail sem enviar via SMTP
    delivered_mail = TesteMailer.teste_email.message

    # Verifica se o destinatário está presente
    raise "Destinatário não definido no Mailer" if delivered_mail.to.blank?

    # Codifica o conteúdo MIME completo
    raw_message = Base64.urlsafe_encode64(delivered_mail.to_s)

    # Cria a mensagem para o Gmail API
    gmail_message = Google::Apis::GmailV1::Message.new(raw: raw_message)

    # Envia via Gmail API
    service.send_user_message('me', gmail_message)

    render plain: 'E-mail enviado com sucesso via Gmail API!'
  rescue => e
    render plain: "Erro ao enviar e-mail: #{e.message}\n\n#{e.backtrace.join("\n")}"
  end

    
end
