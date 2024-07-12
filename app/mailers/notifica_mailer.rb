class NotificaMailer < ApplicationMailer
  default charset: 'UTF-8'
  default content_transfer_encoding: '8bit'
  
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
  def confirmacao(user, titulo, eventode, eventoate, horaini, horafim)

    @user = Usuario.find_by(id: user)
    @evento = titulo
    @de = eventode
    @ate = eventoate
    @hini = horaini
    @hfim = horafim

    mail to: @user.emailPrincipalUsuario, subject: "Evento registrado - Pendente"

  end

  def confirmacaosuper(salaid, salanome, eventonome, eventode, eventoate, horaini, horafim)

    @sala = salanome
    @evento = eventonome
    @de = eventode
    @ate = eventoate
    @hini = horaini
    @hfim = horafim

    # 1 - Admin
    # 2 - Supervisor
    @super = Permissao.where(perfil_id: [1,2], sala_id: salaid)

    @super.each do |su|

      @usersuper = Usuario.find_by(id: su.usuario_id)

      #mail to: @usersuper.emailPrincipalUsuario, subject: "Evento novo - Favor confirmar/negar"
      
      mail(
	      to: @usersuper.emailPrincipalUsuario,
	      subject: 'Evento novo - Favor confirmar/negar'
	    ) do |format|
	      format.text { render plain: render_to_string('notifica_mailer/confirmacaosuper.text.erb') }
	      format.html { render html: render_to_string('notifica_mailer/confirmacaosuper.html.erb').html_safe }
      end
           
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

    mail to: @user.emailPrincipalUsuario, subject: "Acesso ao equipamento restrito - Sistemas de agendas"
  end


  def permissaosalaadm(user, sala, perfil, usercad)
    
    @useradm = Usuario.find_by(id: user)

    @usercadastrado = Usuario.find_by(id: usercad)
    
    @sala = Sala.find_by(id: sala)

    @perfil = perfil

    mail to: @useradm.emailPrincipalUsuario, subject: "Acesso ao equipamento restrito - Sistemas de agendas"
  end

  def remocaosala(user, sala)

    @user = Usuario.find_by(id: user)
    
    @sala = Sala.find_by(id: sala)

    mail to: @user.emailPrincipalUsuario, subject: "Remoção de acesso ao equipamento restrito - Sistemas de agendas"    

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

  def permissaoagendauser(agenda, user)

    @useratual = Usuario.find_by(id: user)
    
    @agenda = Agenda.find_by(id: agenda)

    mail to: @useratual.emailPrincipalUsuario, subject: "Permissão de usuário - Sistema de agendas"

    # mail(:to =>  @usersuper.emailPrincipalUsuario, :subject => "Permissão de usuário - Agenda") do |format|
    #   format.text 
    #   format.html 
    # end

  end 

  def permissaoagenda(agenda, user)

    @user = Usuario.find_by(id: user)

    @agenda = Agenda.find_by(id: agenda)

    @salasx = Sala.where(agenda_id: agenda)

    @salasx.each do |s| 

      @super = Permissao.where(perfil_id: [2, 1], sala_id: s.id)

      @super.each do |su|

        @usersuper = Usuario.find_by(id: su.usuario_id)

        mail(:to =>  @usersuper.emailPrincipalUsuario, :subject => "Permissão de usuário - Agenda") do |format|
          format.text 
          format.html 
        end

      end

    end
    
  end

end

=begin 
Notificações de e-mail:

01) Esqueci a senha
02) Aviso de horário livre
03) Confirmação para usuário de que o agendamento foi criado
04) Confirmação para o supervisor/admin agendamento criado e pendente para confirmar ou negar
05) Para usuário = cada vez que ele se inscreve em um equipamento ou se o perfil dele esta sendo alterado (Admin, Supervisor, Acesso Simples)
06) Para admin quando o cara se cadastra na sala
07) Remoção de acesso para usuário
08) Status do agendamento para o usuário 
09) Status negado para Admin 
10) Permissão na agenda para usuário 
11) Permissão na agenda para supervisor/admin
=end
