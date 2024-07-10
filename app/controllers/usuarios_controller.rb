class UsuariosController < ApplicationController
  before_action :set_usuario, only: [:show, :edit, :update, :destroy]
  before_action :autenticado?, only: [:show, :edit, :update, :destroy, :index]

  # GET /usuarios
  # GET /usuarios.json
  def index
    
    @useradmin = false 
    @inscricao = Inscricao.joins(:usuario).joins(:agenda).where("usuarios.loginUsuario = ? and usertipo = 'Admin'", session[:login]).select("agenda_id")
    
    agendas = Array.new

    @inscricao.each do |i|
      agendas << i.agenda_id
      @useradmin = true
    end 
    
    userdasagendas = Array.new
    if session[:admingeral] == true
      @usuarios = Usuario.all
    elsif @useradmin == true 
      @inscritos = Inscricao.where(" agenda_id in (?) ", agendas)
      @inscritos.each do |is|
        userdasagendas << is.usuario_id 
      end 
      @usuarios = Usuario.where("id in (?) ", userdasagendas)
    else
      @usuarios = Usuario.where(loginUsuario: session[:login])
    end 
  end

  # GET /usuarios/1
  # GET /usuarios/1.json
  def show
  end

  # GET /usuarios/new
  def new
    @usuario = Usuario.new
    @usuario.tipoUsuario = "EXTERNO"
  end

  # GET /usuarios/1/edit
  def edit
  end

  # POST /usuarios
  # POST /usuarios.json
  def create
    @usuario = Usuario.new(usuario_params)

    @usuario.tipoUsuario = "EXTERNO"
    @usuario.loginUsuario = @usuario.emailPrincipalUsuario

    respond_to do |format|
      if @usuario.save
        format.html { redirect_to @usuario, notice: 'Usuário foi criado com sucesso.' }
        format.json { render :show, status: :created, location: @usuario }
      else
        format.html { render :new }
        format.json { render json: @usuario.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /usuarios/1
  # PATCH/PUT /usuarios/1.json
  def update
    respond_to do |format|
      if @usuario.update(usuario_params)
        format.html { redirect_to @usuario, notice: 'Usuário foi atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @usuario }
      else
        format.html { render :edit }
        format.json { render json: @usuario.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /usuarios/1
  # DELETE /usuarios/1.json
  def destroy
    @usuario.destroy
    respond_to do |format|
      format.html { redirect_to usuarios_url, notice: 'Usuário foi apagado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_usuario
      @usuario = Usuario.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def usuario_params
      params.require(:usuario).permit(:nomeUsuario, :loginUsuario, :tipoUsuario, :emailPrincipalUsuario, :emailAlternativoUsuario, :emailUspUsuario, :numeroTelefoneFormatado, :ramalUsp, :password, :password_confirmation, :cpf, :endereco, :tel_contato, :instituicao, :vinculo)
    end
end