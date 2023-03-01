class TipoVinculosController < ApplicationController
  before_action :set_tipo_vinculo, only: [:show, :edit, :update, :destroy]

  # GET /tipo_vinculos
  # GET /tipo_vinculos.json
  def index
    @tipo_vinculos = TipoVinculo.all
  end

  # GET /tipo_vinculos/1
  # GET /tipo_vinculos/1.json
  def show
  end

  # GET /tipo_vinculos/new
  def new
    @tipo_vinculo = TipoVinculo.new
  end

  # GET /tipo_vinculos/1/edit
  def edit
  end

  # POST /tipo_vinculos
  # POST /tipo_vinculos.json
  def create
    @tipo_vinculo = TipoVinculo.new(tipo_vinculo_params)

    respond_to do |format|
      if @tipo_vinculo.save
        format.html { redirect_to @tipo_vinculo, notice: 'Vínculo foi criado com sucesso.' }
        format.json { render :show, status: :created, location: @tipo_vinculo }
      else
        format.html { render :new }
        format.json { render json: @tipo_vinculo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tipo_vinculos/1
  # PATCH/PUT /tipo_vinculos/1.json
  def update
    respond_to do |format|
      if @tipo_vinculo.update(tipo_vinculo_params)
        format.html { redirect_to @tipo_vinculo, notice: 'Vínculo foi atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @tipo_vinculo }
      else
        format.html { render :edit }
        format.json { render json: @tipo_vinculo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tipo_vinculos/1
  # DELETE /tipo_vinculos/1.json
  def destroy
    @tipo_vinculo.destroy
    respond_to do |format|
      format.html { redirect_to tipo_vinculos_url, notice: 'Vínculo foi apagado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tipo_vinculo
      @tipo_vinculo = TipoVinculo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tipo_vinculo_params
      params.require(:tipo_vinculo).permit(:tipoVinculo, :codigoSetor, :nomeAbreviadSetor, :nomeSetor, :codigoUnidade, :siglaUnidade, :nomeUnidade, :nomeVinculo, :nomeAbreviadoFuncao, :usuario_id)
    end
end
