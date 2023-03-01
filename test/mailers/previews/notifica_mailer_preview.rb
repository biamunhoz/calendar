# Preview all emails at http://localhost:3000/rails/mailers/notifica_mailer
class NotificaMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/notifica_mailer/confirmacao
  def confirmacao
    NotificaMailer.confirmacao
  end

  # Preview this email at http://localhost:3000/rails/mailers/notifica_mailer/permissaosala
  def permissaosala
    NotificaMailer.permissaosala
  end

end
