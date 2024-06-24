class AgendasController < ApplicationController
  before_action :set_agenda, only: [:show, :edit, :update, :destroy]

  # GET /agendas
  # GET /agendas.json
  def index

    @inscricao = Inscricao.joins(:usuario).joins(:agenda).where("usuarios.loginUsuario = ? ", session[:login]).select("usertipo, agenda_id")
    if session[:admingeral] == true
      @agendas = Agenda.all
    else      
      @agendas = carrega_agendas
    end   

  end

  def inscreveoutro

    iduser = params[:id]
    agenda = params[:ag]
    @tipoagenda = Agenda.find_by(id: agenda)
    @valida = Inscricao.find_by(usuario_id: iduser, agenda_id: agenda)

    if @valida.nil?

      @insc = Inscricao.new
      @insc.usuario_id = iduser
      @insc.agenda_id = agenda
      @insc.tipo = "Inscrito"
      @insc.usertipo = "Simples"
      @insc.save!

      NotificaMailer.permissaoagendauser(agenda, iduser).deliver_now!
    
      addpermissao(agenda, iduser)

    end 
    
  end 


  def inscricao

    if session[:login] == nil      
      redirect_to login_path
    else  

      @agenda = params[:id]

      @tipoagenda = Agenda.find_by(id: @agenda)

      @valida = Inscricao.find_by(usuario_id: current_user.id, agenda_id:@agenda)

      if @valida.nil?

        if @tipoagenda.tipo == 'Publica'

          if @tipoagenda.validaextra == true

            @insc = Inscricao.new
            @insc.usuario_id = current_user.id
            @insc.agenda_id = @agenda
            @insc.tipo = "Pendente"
            @insc.usertipo = "Simples"
            @insc.save!
  
            NotificaMailer.permissaoagenda(@agenda, current_user.id).deliver_now!
            NotificaMailer.permissaoagendauser(@agenda, current_user.id).deliver_now!
          
            @confirmado = false
            print "Aqui 1**********************"
          else

            @insc = Inscricao.new
            @insc.usuario_id = current_user.id
            @insc.agenda_id = @agenda
            @insc.tipo = "Inscrito"
            @insc.usertipo = "Simples"
            @insc.save!

            NotificaMailer.permissaoagenda(@agenda, current_user.id).deliver_now!
            NotificaMailer.permissaoagendauser(@agenda, current_user.id).deliver_now!
          
            addpermissao(@agenda, current_user.id)
            @confirmado = true
            print "Aqui 2*************************"
          end 

        else

          @insc = Inscricao.new
          @insc.usuario_id = current_user.id
          @insc.agenda_id = @agenda
          @insc.tipo = "Pendente"
          @insc.usertipo = "Simples"
          @insc.save!

          NotificaMailer.permissaoagenda(@agenda, current_user.id).deliver_now!
          NotificaMailer.permissaoagendauser(@agenda, current_user.id).deliver_now!

          @confirmado = false

          print "Aqui 3**************************"
        end

      else
        @confirmado = true
        print "Aqui 4 ***********************"
      end

    end  
    
  end  

  def verinscritos

    @agenda = params[:id]

    @insc = Inscricao.joins(:usuario).joins(:agenda).where(agenda_id: @agenda)

    @souadmin = false 
    @insc.each do |inscricao|
      if inscricao.usertipo == "Admin"
        if inscricao.usuario_id == current_user.id
          @souadmin = true 
        end
      end 
    end

    #select * from usuarios where id not in (select usuario_id from inscricaos where agenda_id = 5);
    @userseminsc = Usuario.where("id not in (select usuario_id from inscricaos where agenda_id = ? )", @agenda) 

  end

  #fazer rotina
  def alterusertipo 
  
    @insc = Inscricao.find_by(:id => params[:id])
    
    if @insc.usertipo == "Simples"
      @insc.usertipo = "Admin"
    else 
      @insc.usertipo = "Simples"
    end 

    @insc.save!

  end 


  def alternegar

    @insc = Inscricao.find_by(:id => params[:id])
    
    @insc.tipo = "Negado"
    @insc.usertipo = ""
    @insc.save!

    # apagar as permissões para todas as salas da agenda em questão...
    @salasdaagenda = Sala.where(agenda_id: @insc.agenda)

    @salasdaagenda.each do |s|
    
      @permissao = Permissao.find_by(usuario_id: @insc.usuario_id, sala_id: s.id)

      @permissao.destroy! unless @permissao.nil?

    end   

    NotificaMailer.inscricaoagenda(@insc.id, "Rejeitada").deliver_now!

  end

  def alterinscrito
    
    @insc = Inscricao.find_by(:id => params[:id])

    @insc.tipo = "Inscrito"
    @insc.usertipo = "Simples"
    @insc.save!

    NotificaMailer.inscricaoagenda(@insc.id, "Aprovada").deliver_now!

  end

  ### Adiciona usuario em salas com permissao automatica
  def addpermissao(agenda, usuario)

    @salas = Sala.where(agenda_id: agenda, permissaoauto: true)

    @salas.each do |s|

      @p = Permissao.new
      @p.usuario_id = usuario
      @p.sala_id = s.id
      @p.perfil_id = Perfil.find_by(:nomeperfil => 'Simples').id

      @p.save!
    end 

  end

  # GET /agendas/1
  # GET /agendas/1.json
  def show
  end

  # GET /agendas/new
  def new
    @agenda = Agenda.new
  end

  # GET /agendas/1/edit
  def edit
  end

  # POST /agendas
  # POST /agendas.json
  def create
    @agenda = Agenda.new(agenda_params)

    respond_to do |format|
      if @agenda.save
        format.html { redirect_to @agenda, notice: 'Agenda foi criada com sucesso.' }
        format.json { render :show, status: :created, location: @agenda }
      else
        format.html { render :new }
        format.json { render json: @agenda.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /agendas/1
  # PATCH/PUT /agendas/1.json
  def update
    respond_to do |format|
      if @agenda.update(agenda_params)
        format.html { redirect_to @agenda, notice: 'Agenda foi alterada com sucesso.' }
        format.json { render :show, status: :ok, location: @agenda }
      else
        format.html { render :edit }
        format.json { render json: @agenda.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /agendas/1
  # DELETE /agendas/1.json
  def destroy
    @agenda.destroy
    respond_to do |format|
      format.html { redirect_to agendas_url, notice: 'Agenda foi apagada com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_agenda
      @agenda = Agenda.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def agenda_params
      params.require(:agenda).permit(:nome, :apresentacaotelaini, :observacao, :tipo, :validaextra, :usertipo, :reservadoformextra, :mostrainfouser)
    end
end

=begin

 Eu preciso criar sempre uma agenda ;
 Ela precisa ter pelo menos uma sala;
 E tambem um supervisor 
 
=end