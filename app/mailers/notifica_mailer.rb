class NotificaMailer < ApplicationMailer

  def senha_reset(usuario)
    @usuario = usuario
    mail({
             to: @usuario.emailPrincipalUsuario,
             subject: "Alteração de senha",
             date: Time.now
         })
  end
  
  def avisohorariovago(email, ini, fim, nomesala, nomeuser)
    
    @ini = ini 
    @fim = fim
    @local = nomesala
    @nomeUsuario = nomeuser

    mail to: email, subject: "Horário Vago"

  end
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifica_mailer.confirmacao.subject
  def confirmacao(user, titulo)

    @user = Usuario.find_by(id: user)
    @evento = titulo

    mail to: @user.emailPrincipalUsuario, subject: "Evento criado - Pendente"

  end

  def confirmacaosuper(salaid, salanome, eventonome, eventode, eventoate)

    @sala = salanome
    @evento = eventonome
    @de = eventode
    @ate = eventoate

    # 2 - Supervisor
    @super = Permissao.where(perfil_id: 2, sala_id: salaid)

    @super.each do |su|

      @usersuper = Usuario.find_by(id: su.usuario_id)

      mail to: @usersuper.emailPrincipalUsuario, subject: "Evento pendente - Favor confirmar/negar"
    end

  end 

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifica_mailer.permissaosala.subject
  #
  def permissaosala(user, sala, perfil)
    
    @user = Usuario.find_by(id: user)
    
    @sala = Sala.find_by(id: sala)

    @perfil = perfil

    mail to: @user.emailPrincipalUsuario, subject: "Acesso a sala restrita - Sistemas de agendas"
  end

  def eventopendente(eventoid, usuarioid, status)
    
    @status = status
    @user = Usuario.find_by(id: usuarioid)
    @evento = Event.find_by(id: eventoid)

    mail to: @user.emailPrincipalUsuario, subject: "Informação do status do evento cadastrado"

  end

  def notificaadmineventonegado(eventoid, idadmin, status)
    
    @status = status
    @user = Usuario.find_by(id: idadmin)
    @evento = Event.find_by(id: eventoid)
    
    @userdoevento = Usuario.find_by(id: @evento.usuario_id)


    mail to: @user.emailPrincipalUsuario, subject: "Informação do status do evento cadastrado"

  end

  def inscricaoagenda(idinscr, status)
    
    @status = status
    @insc = Inscricao.where(id: idinscr)

    @insc.each do |i|
      @user = Usuario.find_by(id: i.usuario_id)
      @agenda = Agenda.find_by(id: i.agenda_id)  

      mail to: @user.emailPrincipalUsuario, subject: "Permissão de usuário - Sistema de agendas"
    end

  end


  def permissaoagenda(agenda, user)

    @user = Usuario.find_by(id: user)

    @agenda = Agenda.find_by(id: agenda)

    @salasx = Sala.where(agenda_id: agenda)

    @salasx.each do |s| 

      @super = Permissao.where(perfil_id: [2, 1], sala_id: s.id)

      @super.each do |su|

        @usersuper = Usuario.find_by(id: su.usuario_id)

        #mail to:,  subject: "Permissão de usuário - Agenda"

        mail(:to =>  @usersuper.emailPrincipalUsuario, :subject => "Permissão de usuário - Agenda") do |format|
          format.text 
          format.html 
        end

      end

    end
    
  end

end
