class ApplicationMailer < ActionMailer::Base
  #default from: 'teste-envio2@icb.usp.br'
  default from: 'naoresponder@icb.usp.br'
  layout 'mailer'
end
