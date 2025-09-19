class TesteMailer < ApplicationMailer

  #tentativa de envio via gmail api
  def teste_email
    mail(
      to: '',
      subject: 'Teste com Gmail API via Mailer'
    ) do |format|
      format.html { render html: "<p>Olá, este é um teste via Gmail API!</p>".html_safe }
    end
  end
end




