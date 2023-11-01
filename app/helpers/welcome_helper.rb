module WelcomeHelper

  #cria uma sessão
  def log_in(loginUsuario)
    session[:login] = loginUsuario
    session[:admingeral] = false

    @user = Usuario.find_by(:loginUsuario => loginUsuario)

    @vinculo = TipoVinculo.where(:usuario_id => @user.id)

    @vinculo.each do |v|
      print v.codigoSetor
      if v.codigoSetor.to_s() == '3610'
        session[:admingeral] = true
      end 
    end
  end

  #destroi a sessão criada na def anterior
  def log_out

    session[:admingeral] = false
    
    session.destroy
    @current_user = nil
  end

  def current_user
    @current_user ||= Usuario.find_by(loginUsuario: session[:login])
  end


  def carrega_agendasprivadas

    @agendas = Inscricao.where(tipo: "Inscrito", usuario_id:  current_user.id)

  end 

  def carrega_salas

    print "*********************************"
    #@permissao = Permissao.where(usuario_id: current_user.id)

    @permissao = Permissao.where(usuario_id: current_user.id, perfil_id: [1,2,3])
    
    salaspermitidas = Array.new
    @permissao.each do |p|
      salaspermitidas << p.sala_id
    end

    if session[:admingeral] == true
      @salas = Sala.all
    else 
      @salas = Sala.where(" id in (?) ", salaspermitidas)
    end 
    

  end 

  def carrega_agendas

    @salas = carrega_salas

    agendaspermitidas = Array.new

    @salas.each do |a|
      agendaspermitidas << a.agenda_id
    end

    @agprivadas = carrega_agendasprivadas

    @agprivadas.each do |a|
      agendaspermitidas << a.agenda_id  
    end

    @agendasid = Agenda.where(" tipo = 'Publica' or id in (?)" , agendaspermitidas).select(:id).distinct

    agendasfinal = Array.new
    @agendasid.each do |aid|
      agendasfinal << aid.id
    end

    @agendas = Agenda.where(" id in (?) ", agendasfinal)

  end



end
