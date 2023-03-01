require 'test_helper'

class TipoVinculosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tipo_vinculo = tipo_vinculos(:one)
  end

  test "should get index" do
    get tipo_vinculos_url
    assert_response :success
  end

  test "should get new" do
    get new_tipo_vinculo_url
    assert_response :success
  end

  test "should create tipo_vinculo" do
    assert_difference('TipoVinculo.count') do
      post tipo_vinculos_url, params: { tipo_vinculo: { codigoSetor: @tipo_vinculo.codigoSetor, codigoUnidade: @tipo_vinculo.codigoUnidade, nomeAbreviadSetor: @tipo_vinculo.nomeAbreviadSetor, nomeAbreviadoFuncao: @tipo_vinculo.nomeAbreviadoFuncao, nomeSetor: @tipo_vinculo.nomeSetor, nomeUnidade: @tipo_vinculo.nomeUnidade, nomeVinculo: @tipo_vinculo.nomeVinculo, siglaUnidade: @tipo_vinculo.siglaUnidade, tipoVinculo: @tipo_vinculo.tipoVinculo, usuario_id: @tipo_vinculo.usuario_id } }
    end

    assert_redirected_to tipo_vinculo_url(TipoVinculo.last)
  end

  test "should show tipo_vinculo" do
    get tipo_vinculo_url(@tipo_vinculo)
    assert_response :success
  end

  test "should get edit" do
    get edit_tipo_vinculo_url(@tipo_vinculo)
    assert_response :success
  end

  test "should update tipo_vinculo" do
    patch tipo_vinculo_url(@tipo_vinculo), params: { tipo_vinculo: { codigoSetor: @tipo_vinculo.codigoSetor, codigoUnidade: @tipo_vinculo.codigoUnidade, nomeAbreviadSetor: @tipo_vinculo.nomeAbreviadSetor, nomeAbreviadoFuncao: @tipo_vinculo.nomeAbreviadoFuncao, nomeSetor: @tipo_vinculo.nomeSetor, nomeUnidade: @tipo_vinculo.nomeUnidade, nomeVinculo: @tipo_vinculo.nomeVinculo, siglaUnidade: @tipo_vinculo.siglaUnidade, tipoVinculo: @tipo_vinculo.tipoVinculo, usuario_id: @tipo_vinculo.usuario_id } }
    assert_redirected_to tipo_vinculo_url(@tipo_vinculo)
  end

  test "should destroy tipo_vinculo" do
    assert_difference('TipoVinculo.count', -1) do
      delete tipo_vinculo_url(@tipo_vinculo)
    end

    assert_redirected_to tipo_vinculos_url
  end
end
