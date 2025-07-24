class SalasController < ApplicationController
  before_action :set_sala, only: [:show, :edit, :update, :destroy]
  before_action :autenticado?

  def consulta
    @agenda = params[:id]
    
    @inscricao = Inscricao.joins(:usuario).joins(:agenda).where("usuarios.loginUsuario = ? ", session[:login]).select("usertipo, agenda_id")

    @salas = Sala.where(agenda_id: @agenda)
  end   

  def permissao
    @sala = params[:id]

    @permitidos = Permissao.joins(:usuario).joins(:perfil)
    .joins(" inner join tipo_vinculos on usuarios.id = tipo_vinculos.usuario_id ").where(sala_id: @sala)
    .select("permissaos.usuario_id, nomeUsuario, emailPrincipalUsuario,  tipoVinculo, nomeSetor, siglaUnidade, sala_id, nomeperfil")

    @permitidosext = Permissao.joins(:usuario).joins(:perfil).where(sala_id: @sala).where(' tipoUsuario= "Externo" ')
    .select("permissaos.usuario_id, nomeUsuario, emailPrincipalUsuario,  'Externo' as tipoVinculo, 'Externo' as nomeSetor, 'Externo' as siglaUnidade, sala_id, nomeperfil")

    @usuarios = Permissao.where(sala_id: @sala).select("usuario_id")

    @negados = Usuario.joins(:tipo_vinculos).where('usuarios.id not in (?) ', @usuarios)
    .select("usuarios.id, nomeUsuario, emailPrincipalUsuario, tipoVinculo, nomeSetor, siglaUnidade")

    @negadosext = Usuario.where('id not in (?) and tipoUsuario = "EXTERNO"', @usuarios)
    .select(" id, nomeUsuario, emailPrincipalUsuario, 'Externo' as tipoVinculo, 'Externo' as nomeSetor, 'Externo' as siglaUnidade ")
    
  end 

  def salvaperfil(perfil, sala, user)
    
    @permissao = Permissao.find_by(sala_id: sala, usuario_id: user)

    if @permissao.nil?
      @p = Permissao.new
      @p.usuario_id = user
      @p.sala_id = sala
      @p.perfil_id = perfil

      @p.save!
    
      return true 
    else
      @permissao.perfil_id = @perfil 
      @permissao.save!

      return false
    end 
    
  end

  def addadmin
 
    @perfil = Perfil.find_by(:nomeperfil => 'Admin').id
    @registrado = salvaperfil(@perfil, params[:sala], params[:id])

    ## Fim do contrato com a Nitronews
    ##NotificaMailer.permissaosala(params[:id], params[:sala], "Administrador").deliver_now!

  end 

  def altersuper
    @perfil = Perfil.find_by(:nomeperfil => 'Supervisor').id
    @registrado = salvaperfil(@perfil, params[:sala], params[:id])
    
    ## Fim do contrato com a Nitronews
    ##NotificaMailer.permissaosala(params[:id], params[:sala], "Supervisor").deliver_now!

  end  

  def altersimples
    @perfil = Perfil.find_by(:nomeperfil => 'Simples').id
    @registrado = salvaperfil(@perfil, params[:sala], params[:id])

    ## Fim do contrato com a Nitronews
    ## NotificaMailer.permissaosala(params[:id], params[:sala], "Simples").deliver_now!

  end   


  def alterpendente
    @perfil = Perfil.find_by(:nomeperfil => 'Pendente').id
    @registrado = salvaperfil(@perfil, params[:sala], params[:id])

    ## Fim do contrato com a Nitronews
    ## NotificaMailer.permissaosala(params[:id], params[:sala], "Pendente").deliver_now!
    
    ## Fim do contrato com a Nitronews
    #Notifica admins    
    #@admins = Sala.joins(:permissaos).where(id: params[:sala])
    #          .where(" permissaos.perfil_id in (1,2) ").select("salas.*, permissaos.usuario_id")
    #@admins.each do |adm|
      ## NotificaMailer.permissaosalaadm(adm.usuario_id, params[:sala], "Pendente", params[:id]).deliver_now!  
    #end 
  end   

  def removeracesso

    @permissao = Permissao.find_by(sala_id: params[:sala], usuario_id: params[:id])
    @permissao.destroy!

    ## Fim do contrato com a Nitronews
    ## NotificaMailer.remocaosala(params[:id], params[:sala]).deliver_now!

  end 

  # GET /salas
  # GET /salas.json
  def index
    @salas = carrega_salas
    #select * from permissaos p inner join perfils f on p.perfil_id = f.id where usuario_id = 1 and nomeperfil = 'Admin'
    #@salacomoadmin = Permissao.joins(:perfil).where(usuario_id: current_user.id, nomeperfil: "Admin")
    if params[:sala_id].present?
      @salas = Sala.where(id: params[:sala_id])
    end

    @salas 

    salaspermitidas = Array.new

    @salas.each do |a|
        salaspermitidas << a.id
    end

    @salasescondidas = Sala.where(permissaoauto: false).where("id not in (?)", salaspermitidas)

    @inscricao = Inscricao.joins(:usuario).joins(:agenda).where("usuarios.loginUsuario = ? ", session[:login]).select("usertipo, agenda_id")

  end

  # GET /salas/1
  # GET /salas/1.json
  def show
  end

  # GET /salas/new
  def new

    #Alterado botão Novo equipamento
    @agenda = Inscricao.joins(:usuario).joins(:agenda).where("usuarios.loginUsuario = ? and usertipo = 'Admin'", session[:login]).select("agenda_id, nome")

    @sala = Sala.new

  end

  # GET /salas/1/edit
  def edit

    #Alterado botão Novo equipamento
    @agenda = Inscricao.joins(:usuario).joins(:agenda).where("usuarios.loginUsuario = ? and usertipo = 'Admin'", session[:login]).select("agenda_id, nome")

  end

  # POST /salas
  # POST /salas.json
  def create
    @sala = Sala.new(sala_params)

    respond_to do |format|
      if @sala.save

        if @sala.permissaoauto == true 
          puts "Permissao automatica OKOKOKOKOKOKOKOKOK"
          addpermissao(@sala.agenda_id, @sala.id)
        end 

        format.html { redirect_to @sala, notice: 'Equipamento foi criado com sucesso.' }
        format.json { render :show, status: :created, location: @sala }
      else
        format.html { render :new }
        format.json { render json: @sala.errors, status: :unprocessable_entity }
      end
    end
  end

#### Nova sala com permissao automatica
  def addpermissao(agenda, sala)
    @insc = Inscricao.where(agenda_id: agenda).select('usuario_id') 

    @insc.each do |i|
      @p = Permissao.new
      @p.usuario_id = i.usuario_id
      @p.sala_id = sala
      @p.perfil_id = Perfil.find_by(:nomeperfil => 'Simples').id

      @p.save!
    end  

  end  

  # PATCH/PUT /salas/1
  # PATCH/PUT /salas/1.json
  def update
    respond_to do |format|
      if @sala.update(sala_params)
        if @sala.permissaoauto == true
          alterpermissao(@sala.id, @sala.agenda_id)
        end  
        format.html { redirect_to @sala, notice: 'Equipamento foi atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @sala }
      else
        format.html { render :edit }
        format.json { render json: @sala.errors, status: :unprocessable_entity }
      end
    end
  end

### Alteraçao de sala 
  def alterpermissao(sala, agenda)
    @insc = Inscricao.where(agenda_id: agenda).select('usuario_id') 

    @insc.each do |i|
    
      @permissao = Permissao.find_by(sala_id: sala, usuario_id: i.usuario_id)

      if @permissao.nil?
        @p = Permissao.new
        @p.usuario_id = i.usuario_id
        @p.sala_id = sala
        @p.perfil_id = Perfil.find_by(:nomeperfil => 'Simples').id
  
        @p.save!
      end 

    end  

  end  

  # DELETE /salas/1
  # DELETE /salas/1.json
  def destroy

    
    @sala.destroy
    respond_to do |format|
      format.html { redirect_to salas_url, notice: 'Equipamento foi apagado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sala
      @sala = Sala.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sala_params
      params.require(:sala).permit(:nome, :cor, :permissaoauto, :observacao, :confirmacao, :agenda_id, :avisoadmhoravaga, :limiteqtdeuso, :limitehoras, :bloqforaintervalo ,:prihoraini, :prihorafim, :seghoraini, :seghorafim, :valorinterval, :disablefds, :permitiapagarevento, :anonimo)
    end
end