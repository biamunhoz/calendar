class EventsController < ApplicationController
  include ApplicationHelper

  before_action :set_event, only: [:show, :edit, :update, :destroy]

  before_action :autenticado?, only: [:show, :edit, :update, :destroy, :index, :confirmarevento, :negarevento, :listagem]

  # GET /events
  # GET /events.json

  def index

  #  @events = Event.joins(:agendamentos).where("sala_id in (?)", salaspermitidas).select("events.id, Concat(events.title,' - ' ,events.registropara) as title, 
  #  events.start_date, events.end_date, events.timeini, events.timefim, agendamentos.data_inicio, agendamentos.data_fim, 
  #  agendamentos.hora_inicio, agendamentos.hora_fim, events.descricao, events.registropara, events.usuario_id, events.sala_id")

  #  o campo title concatenado é onde criamos o que vai ser mostrado no calendário
 
    @salas = Sala.joins(:permissaos).where(" permissaos.perfil_id in (1,2) and permissaos.usuario_id = ? ", current_user.id).select("salas.id")
 
    @ehadmindesala = false 
    @salas.each do |ehadmin|
      @ehadmindesala = true
    end

    @events = Event.joins(:agendamentos).joins(" inner join salas on events.sala_id = salas.id ")
    .where(" desmarcado = false and sala_id in (?)", salaspermitidas)
    .select("events.id, Concat(time_format(events.timeini, '%H:%i'), ' - ', time_format(events.timefim, '%H:%i'), ' - ', salas.nome,' - ' ,events.registropara ,' - ', if (pendente = 1, ' ⧗ EA', ' Ⓥ')) as title, 
    events.start_date, events.end_date, events.timeini, events.timefim, agendamentos.data_inicio, agendamentos.data_fim, 
    agendamentos.hora_inicio, agendamentos.hora_fim, events.descricao, events.registropara, events.usuario_id, events.sala_id, salas.cor")

    
    @salasdaagenda = Sala.where("id in (?)", salaspermitidas)

    #json.backgroundColor '#9297dd'
    #json.borderColor '#9297dd'

  end

  def resultagenda
    
    #considerar aqui as permissões 
    @events = Event.joins(:agendamentos).joins(" inner join salas on events.sala_id = salas.id ")
    .where("desmarcado = false and sala_id in (?)", @@salamostrar)
    .select("events.id, Concat(time_format(events.timeini, '%H:%i'), ' - ', time_format(events.timefim, '%H:%i'), ' - ', events.title,' - ' ,events.registropara ,' - ', if (pendente = 1, ' ⧗ EA', ' Ⓥ')) as title,  
    events.start_date, events.end_date, events.timeini, events.timefim, agendamentos.data_inicio, agendamentos.data_fim, 
    agendamentos.hora_inicio, agendamentos.hora_fim, events.descricao, events.registropara, events.usuario_id, events.sala_id, salas.cor")

  end

  def confirmarevento

    @event = Event.find_by(:id => params[:id])
    
    @event.pendente = false
    @event.save!

    NotificaMailer.eventopendente(@event.id, @event.usuario_id, "Confirmado").deliver_now!

    redirect_to events_url, notice: 'Evento confirmado'

  end

  def negarevento

    @event = Event.find_by(:id => params[:id])

    NotificaMailer.eventopendente(@event.id, @event.usuario_id, "Negado").deliver_now!
        
    @adminesuper = Permissao.where(perfil_id: [2, 1], sala_id: @event.sala_id)

    @adminesuper.each do |su|

      @usersuper = Usuario.find_by(id: su.usuario_id)
      NotificaMailer.notificaadmineventonegado(@event.id, @usersuper.id, "Negado").deliver_now!

    end 

    @event.destroy
    
    redirect_to events_url, notice: 'Evento negado'

  end

  def carrega_salas


    @permissao = Permissao.where(usuario_id: current_user.id, perfil_id: [1,2,3])

    salaspermitidas = Array.new
    @permissao.each do |p|
      salaspermitidas << p.sala_id
    end

    @salas = Sala.where(" id in (?) ", salaspermitidas)
  end 

  def salaspermitidas

    @salas = carrega_salas

    salaspermitidas = Array.new

    @salas.each do |a|
      salaspermitidas << a.id
    end

    return salaspermitidas
  end

  def listagem

    iddaagenda = params[:iddaagenda]

    if iddaagenda == "0"

      @events = Event.joins(:usuario)
      .where("desmarcado = false and sala_id in (?)", salaspermitidas)
      .select(" events.*, usuarios.nomeUsuario ").order("start_date desc")

    else
      @events = Event.joins(:usuario)
      .where("desmarcado = false and sala_id in (?)", salasdaagenda(iddaagenda))
      .select(" events.*, usuarios.nomeUsuario ").order("start_date desc")
    end 

  end

  def salasdaagenda(agenda)
 

    @permissao = Permissao.where(usuario_id: current_user.id, perfil_id: [1,2,3])

    salaspermitidas = Array.new
    @permissao.each do |p|
      salaspermitidas << p.sala_id
    end

    @salas = Sala.where(agenda_id: agenda)
    salaselecionada  = Array.new

    @salas.each do |a|

      if salaspermitidas.include?(a.id) == true
        salaselecionada << a.id
      end 
    end

    return salaselecionada
  end

  def eventoagenda
   
    @agendasel = params[:id]

    @@salamostrar = salasdaagenda(@agendasel)
    @salasdaagenda = Sala.where(:id => @@salamostrar)
    
    #@@salamostrar = salaspermitidas    
    #@salasdaagenda = Sala.where(:id => salaspermitidas)
    @dadosagenda = Agenda.where(:id => @agendasel)   
    
  end 

  def eventoagendalivres
    @@salamostrar = Sala.where("agenda_id in (select id from agendas where apresentacaotelaini = 1 and tipo = 'Publica')").select(" id ")
  end 

  def agendamentos

    @agendamentos = Agendamento.where(event_id: params[:id])
    @eventodoagendamento = Event.includes(:sala).find(params[:id])

  end

  def deleteagend

    @agendamento = Agendamento.find(params[:id])

    @evento = Event.find_by(id: @agendamento.event_id)

    @sala = Sala.find_by(id: @evento.sala_id)

    if @sala.avisoadmhoravaga == true

      @ini = @agendamento.data_inicio.strftime("%d/%m/%Y") + " - " + @agendamento.hora_inicio.strftime("%H:%M")
      @fim = @agendamento.data_fim.strftime("%d/%m/%Y") + " - " + @agendamento.hora_fim.strftime("%H:%M")

      @supers = Permissao.where(sala_id: @sala.id , perfil_id: 2)
      
      @supers.each do |s|
        @user = Usuario.find_by(id: s.usuario_id)

        NotificaMailer.avisohorariovago(@user.emailPrincipalUsuario, @ini, @fim, @sala.nome, @user.nomeUsuario).deliver_now!
      end 

    end

    @agendamento.destroy

    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Agendamento na data escolhida apagado.' }
      format.json { head :no_content }
    end

  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new

    salasel = params[:idsala]

    @salas = Sala.joins(:permissaos).where(" permissaos.perfil_id in (1,2) and permissaos.usuario_id = ? and salas.id = ? ", current_user.id, salasel ).select("salas.id")
 
    @ehadmindesala = false 
    @salas.each do |ehadmin|
      @ehadmindesala = true
    end

    #@salas = salaspermitidas
    #@salas = Sala.where(" id in (?) ", salasel)

    @sala = Sala.find(salasel)

    # start_time = DateTime.parse("9 AM").to_i
    # start_interval = DateTime.parse("11 AM").to_i
    # end_interval = DateTime.parse("1 PM").to_i
    # end_time = DateTime.parse("3 PM").to_i

    #@values = (start_time..end_time).step(15.minutes).select{|t| t <= start_interval || t >= end_interval }

    if @sala.bloqforaintervalo == true 
      start_time = @sala.prihoraini.to_i
      start_interval = @sala.prihorafim.to_i
      end_interval = @sala.seghoraini.to_i
      end_time = @sala.seghorafim.to_i
      @values = (start_time..end_time).step(@sala.valorinterval.minutes).select{|t| t <= start_interval || t >= end_interval }
      @valuesfim = (start_time..end_time).step(@sala.valorinterval.minutes - 1).select{|t| t <= start_interval || t >= end_interval }

      @valuesfim.each do |hora|
        #print "-----"
        #print Time.at(hora).utc.to_datetime.strftime("%H:%M")

        if Time.at(hora).utc.to_datetime.strftime("%H:%M") == (@sala.prihorafim - 1).strftime("%H:%M")
          #Inclui a ultima hora do primeiro intervalo
          @valuesfim[@valuesfim.index(hora)] << @sala.prihorafim.to_i + (@sala.valorinterval.minutes - 1)
        end 

        if Time.at(hora).utc.to_datetime.strftime("%H:%M") == @sala.prihoraini.strftime("%H:%M")
          #Apaga a primeira hora definida
          @valuesfim.delete_at(@valuesfim.index(hora))
        end 
      end 
     
      #Inclui a ultima hora definida
      @valuesfim << @sala.seghorafim 

    else
      start_time = DateTime.parse("0 AM").to_i
      start_interval = DateTime.parse("11:55 AM").to_i
      end_interval = DateTime.parse("12 PM").to_i
      end_time = DateTime.parse("23:55 PM").to_i
      @values = (start_time..end_time).step(5.minutes).select{|t| t <= start_interval || t >= end_interval }
      @valuesfim = (start_time..end_time).step(5.minutes).select{|t| t <= start_interval || t >= end_interval }
    end

    @event = Event.new
  end

  # GET /events/1/edit
  def edit

    @salas = Sala.joins(:permissaos).where(" permissaos.perfil_id in (1,2) and permissaos.usuario_id = ? ", current_user.id).select("salas.id")
 
    @ehadmindesala = false 
    @salas.each do |ehadmin|
      @ehadmindesala = true
    end

    @sala = Sala.find(@event.sala_id)

    if @sala.bloqforaintervalo == true 
      start_time = @sala.prihoraini.to_i
      start_interval = @sala.prihorafim.to_i
      end_interval = @sala.seghoraini.to_i
      end_time = @sala.seghorafim.to_i
      @values = (start_time..end_time).step(@sala.valorinterval.minutes).select{|t| t <= start_interval || t >= end_interval }
      @valuesfim = (start_time..end_time).step(@sala.valorinterval.minutes - 1).select{|t| t <= start_interval || t >= end_interval }

      @valuesfim.each do |hora|
        #print "-----"
        #print Time.at(hora).utc.to_datetime.strftime("%H:%M")

        if Time.at(hora).utc.to_datetime.strftime("%H:%M") == (@sala.prihorafim - 1).strftime("%H:%M")
          #Inclui a ultima hora do primeiro intervalo
          @valuesfim[@valuesfim.index(hora)] << @sala.prihorafim.to_i + (@sala.valorinterval.minutes - 1)
        end 

        if Time.at(hora).utc.to_datetime.strftime("%H:%M") == @sala.prihoraini.strftime("%H:%M")
          #Apaga a primeira hora definida
          @valuesfim.delete_at(@valuesfim.index(hora))
        end 
      end 
     
      #Inclui a ultima hora definida
      @valuesfim << @sala.seghorafim 

    else
      start_time = DateTime.parse("0 AM").to_i
      start_interval = DateTime.parse("11:55 AM").to_i
      end_interval = DateTime.parse("12 PM").to_i
      end_time = DateTime.parse("23:55 PM").to_i
      @values = (start_time..end_time).step(5.minutes).select{|t| t <= start_interval || t >= end_interval }
      @valuesfim = (start_time..end_time).step(5.minutes).select{|t| t <= start_interval || t >= end_interval }
    end
 
    @salas = salaspermitidas
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    @event.usuario_id =  current_user.id

    @sala = Sala.find_by(id: @event.sala_id)

    bEnviaEmailConfirmacao = false

    if @sala.confirmacao == true
      @event.pendente = true
      bEnviaEmailConfirmacao = true
    else 
      @event.pendente = false 
    end  
    
    respond_to do |format|

        if @event.save   

          horaini = @event.timeini.to_time
          horafim = @event.timefim.to_time
  
          diaini = @event.start_date.to_date
          diafim = @event.end_date.to_date


          if diaini == diafim
            salvaAgendamento(diaini, diafim, horaini, horafim, @event.id)
          else
            diaini.upto(diafim) do |day|
              case day.wday       
                when 0
                  if @event.domingo == true
                    salvaAgendamento(day, day, horaini, horafim, @event.id)
                  end   
                when 1
                  if @event.segunda == true
                    salvaAgendamento(day, day, horaini, horafim, @event.id)
                  end               
                when 2 
                  if @event.terca == true
                    salvaAgendamento(day, day, horaini, horafim, @event.id)
                  end
                when 3 
                  if @event.quarta == true                  
                    salvaAgendamento(day, day, horaini, horafim, @event.id)
                  end
                when 4 
                  if @event.quinta == true
                    salvaAgendamento(day, day, horaini, horafim, @event.id)
                  end
                when 5 
                  if @event.sexta == true
                    salvaAgendamento(day, day, horaini, horafim, @event.id)
                  end
                when 6 
                  if @event.sabado == true
                    salvaAgendamento(day, day, horaini, horafim, @event.id)
                  end             
                end
              
            end
          end 
  
          if bEnviaEmailConfirmacao == true
            NotificaMailer.confirmacao(current_user.id, @event.title, @event.start_date.to_date, @event.end_date.to_date, horaini, horafim).deliver_now!
            NotificaMailer.confirmacaosuper(@event.sala_id, @sala.nome, @event.title, @event.start_date.to_date, @event.end_date.to_date, horaini, horafim).deliver_now!

            format.html { redirect_to @event, notice: 'Evento foi cadastrado com sucesso. Sujeito a avaliação dos administradores, aguarde confirmação.' }
            format.json { render :show, status: :created, location: @event }

          else 
            format.html { redirect_to @event, notice: 'Evento foi criado com sucesso.' }
            format.json { render :show, status: :created, location: @event }
          end
        else
          format.html { redirect_to events_url, notice: @event.errors.messages }
          format.json { render json: @event.errors, status: :unprocessable_entity }
        end 
      end      
      
  end
 
  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    bEnviaEmailConfirmacao = false

    @sala = Sala.find_by(id: @event.sala_id)

    if @sala.confirmacao == true
      @event.pendente = true
      bEnviaEmailConfirmacao = true
    else 
      @event.pendente = false 
    end

    @event.usuario_id =  current_user.id

    respond_to do |format|
      if @event.update(event_params)

        horaini = @event.timeini.to_time
        horafim = @event.timefim.to_time

        diaini = @event.start_date.to_date
        diafim = @event.end_date.to_date

        delAgendamentos(@event.id)

        if diaini == diafim
          salvaAgendamento(diaini, diafim, horaini, horafim, @event.id)
        else
          diaini.upto(diafim) do |day|
            case day.wday       
              when 0
                if @event.domingo == true
                  salvaAgendamento(day, day, horaini, horafim, @event.id)
                end   
              when 1
                if @event.segunda == true
                  salvaAgendamento(day, day, horaini, horafim, @event.id)
                end               
              when 2 
                if @event.terca == true
                  salvaAgendamento(day, day, horaini, horafim, @event.id)
                end
              when 3 
                if @event.quarta == true                  
                  salvaAgendamento(day, day, horaini, horafim, @event.id)
                end
              when 4 
                if @event.quinta == true
                  salvaAgendamento(day, day, horaini, horafim, @event.id)
                end
              when 5 
                if @event.sexta == true
                  salvaAgendamento(day, day, horaini, horafim, @event.id)
                end
              when 6 
                if @event.sabado == true
                  salvaAgendamento(day, day, horaini, horafim, @event.id)
                end             
              end
            
          end
        end

        if bEnviaEmailConfirmacao == true
          NotificaMailer.confirmacao(current_user.id, @event.title, @event.start_date.to_date, @event.end_date.to_date, horaini, horafim).deliver_now!
          NotificaMailer.confirmacaosuper(@event.sala_id, @sala.nome, @event.title, @event.start_date.to_date, @event.end_date.to_date, horaini, horafim).deliver_now!

          format.html { redirect_to @event, notice: 'Evento foi atualizado com sucesso. Sujeito a avaliação dos administradores, aguarde confirmação.' }
          format.json { render :show, status: :created, location: @event }

        else 
          format.html { redirect_to @event, notice: 'Evento foi atualizado com sucesso.' }
          format.json { render :show, status: :created, location: @event }
        end
        
      else
        format.html { redirect_to events_url, notice: @event.errors.messages }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy

    @sala = Sala.find_by(id: @event.sala_id)

    if @sala.avisoadmhoravaga == true

      @ini = @event.start_date.strftime("%d/%m/%Y") + " - " + @event.timeini.strftime("%H:%M")
      @fim = @event.end_date.strftime("%d/%m/%Y") + " - " + @event.timefim.strftime("%H:%M")

      @supers = Permissao.where(sala_id: @event.sala_id, perfil_id: 2)
      
      @supers.each do |s|
        @user = Usuario.find_by(id: s.usuario_id)

        NotificaMailer.avisohorariovago(@user.emailPrincipalUsuario, @ini, @fim, @sala.nome, @user.nomeUsuario).deliver_now!
      end 

    end 

    #@event.destroy

    delAgendamentos(@event.id)

    @event.desmarcado = true
    @event.save!

    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Evento foi apagado com sucesso.' }
      format.json { head :no_content }
    end

  end

  def delAgendamentos(event)

    @ags = Agendamento.where(event_id: event)

    @ags.each do |ag|
      ag.destroy
    end 

  end

  def relgeral

    @de = params[:valorde]
    @ate = params[:valorate]
    tipo = ActiveModel::Type::Boolean.new.cast(params[:marcado])
    @tipomarcacao = tipo
    @sala = params[:sala]
    @resultado = nil

    if @de != ""       
      @resultado = Event.joins(" inner join salas on events.sala_id = salas.id ")
      .joins(" inner join usuarios on events.usuario_id = usuarios.id ")
      .where("desmarcado = ? and sala_id = ? and start_date >= ? and end_date <= ?", tipo, @sala, @de, @ate)
      .select(" Concat(events.title,' - ' ,events.registropara) as title, 
      events.start_date, events.timeini, 
      events.end_date, events.timefim, events.descricao, events.usuario_id, salas.nome, usuarios.nomeUsuario ")
    end 


  end 


  def salvaAgendamento(start_date, end_date, horaini, horafim, event_id)

    @ag = Agendamento.new
    @ag.data_inicio = start_date
    @ag.data_fim = end_date
    @ag.hora_inicio = horaini
    @ag.hora_fim = horafim
    @ag.event_id = event_id

    @ag.save!

  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:title, :start_date, :timeini, :end_date, :timefim, :descricao, :domingo, :segunda, :terca, :quarta, :quinta, :sexta, :sabado, :pendente, :registropara, :sala_id, :usuario_id)
    end
end
